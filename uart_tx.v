`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BU
// Engineer: Josh Wildey
// 
// Create Date:    14:30:25 04/07/2018 
// Module Name:    uart_tx 
// Project Name: Lab 2 - Peripheral and Processor Integration with I/O
// Target Devices: Nexys3 Spartan 6
// Revision 0.01 - File Created
// References:
//   https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html
//
//////////////////////////////////////////////////////////////////////////////////
module uart_tx(
	input wire       clk,         // Input clock from FPGA, 100 MHz (10 ns)
	input wire       tx_wr,       // TX write flag
	input wire [7:0] tx_byte,     // Byte of data to write
	output reg       tx_active,   // Flag to indicate TX is in process
	output reg       tx_data_out, // UART TX Serial Data out
	output reg       tx_done      // TX Flag to indicate done writing byte
   );
	
	// UART Standard Rates: 1200, 2400, 4800, 19200, 38400, 57600, 115200
	parameter UART_RATE = 115200;
	parameter CLK_RATE  = 100000000;  // 100 MHz
	
	// State definitions
	// Use localparams so these cannot be changed
	localparam STATE_IDLE         = 3'b000;
	localparam STATE_TX_START_BIT = 3'b001;
	localparam STATE_TX_DATA_BITS = 3'b010;
	localparam STATE_TX_STOP_BIT  = 3'b011;
	localparam STATE_CLEANUP      = 3'b100;
	
	reg [2:0] state = STATE_IDLE;  // register to save current state;
	
	// Clock Counter
	// Max value of clk_cnt if Baud rate is changed is 100 MHz / 1200 Baud = 83333
	// which requires 17 bits to store
	reg [16:0] clk_cnt = 17'd0;
	
	reg [2:0] bit_idx = 3'd0; // Bit index to count for bytes
	
	reg [7:0] tx_data = 8'd0; // register to hold tx data

	// TX State Machine
	always @ (posedge clk) begin
		case (state)
			STATE_IDLE: begin
				tx_data_out <= 1'b1;  // Drive high while idle
				tx_done <= 1'b0;
				clk_cnt <= 0; //reset counter
				bit_idx <= 3'd0;
				
				// If write enable is active
				if (tx_wr == 1'b1) begin
					tx_active <= 1'b1;
					tx_data <= tx_byte;
					state <= STATE_TX_START_BIT;
				end
				// otherwise remain in idle state
				else begin
					state <= STATE_IDLE;
				end
			end
			
			STATE_TX_START_BIT: begin
				tx_data_out <= 1'b0;  // Low start bit
				
				// Wait for bit width
				if (clk_cnt < ((CLK_RATE / UART_RATE) - 1)) begin
					clk_cnt <= clk_cnt + 1'b1; //increment counter
					state <= STATE_TX_START_BIT;  // stay in state
				end
				// bit width reached
				else begin
					clk_cnt <= 0; //reset counter
					state <= STATE_TX_DATA_BITS;  // move to tx data bits state
				end
			end
			
			STATE_TX_DATA_BITS: begin
				tx_data_out <= tx_data[bit_idx];  // Write Bit
				
				// Wait for bit width
				if (clk_cnt < ((CLK_RATE / UART_RATE) - 1)) begin
					clk_cnt <= clk_cnt + 1'b1; //increment counter
					state <= STATE_TX_DATA_BITS;  // stay in state
				end
				// Index through Data bits
				else begin
					clk_cnt <= 0; //reset counter
					
					// check if we received 8 bits
					if (bit_idx < 7) begin
						bit_idx <= bit_idx + 1'b1;  // increment bit index
						state <= STATE_TX_DATA_BITS; // stay in this state
					end
					// transmitted a byte
					else begin
						bit_idx <= 3'd0;  // reset bit index
						state <= STATE_TX_STOP_BIT; // move to stop bit state
					end
				end
			end
			
			STATE_TX_STOP_BIT: begin
				tx_data_out <= 1'b1;  // High Stop bit
				
				// Wait for bit width
				if (clk_cnt < ((CLK_RATE / UART_RATE) - 1)) begin
					clk_cnt <= clk_cnt + 1'b1; //increment counter
					state <= STATE_TX_STOP_BIT;  // stay in state
				end
				// Stop bit
				else begin
					tx_done <= 1'b1;
					clk_cnt <= 0; //reset counter
					tx_active <= 1'b0;
					state <= STATE_CLEANUP;  // move on to cleanup state
				end
			end
			
			STATE_CLEANUP: begin
				tx_done <= 1'b1;
				state <= STATE_IDLE;
			end
			
			default: begin
				state <= STATE_IDLE;
			end
			
		endcase	
	end

endmodule
