`ifndef _include_wrap_accel_
`define _include_wrap_accel_

`include "accel.v"
`include "kb_buffer.v"

module WrapAccel (
    input  wire [ 7:0] key,
    input  wire        key_valid,
    output wire [ 7:0] print_char,
    output wire        print_valid,
	 output wire [3:0] leds,
    input  wire clk,
    input  wire rst
);

    wire [31:0] buffer;
    wire buffer_valid;
    wire [9:0] buff_value;

    reg [ 7:0] image_dim;
    reg [ 8:0] image_depth;

    reg [1:0] filter_halfsize;
    reg [2:0] filter_stride;
    reg [12:0] filter_length;
    reg [17:0] filter_bias;

    reg [15:0] interface_write_addr;
    reg [17:0] interface_write_data;
    reg interface_write_en;
    reg [1:0] interface_write_sel;

    reg [3:0] read_state;
    reg [11:0] in_ctr;
    reg [11:0] in_ctr_max;

    
    reg accel_active;

    wire [17:0] output_read_data;
    wire output_read_valid;
    
    KbBuffer kb_buffer (
        .key(key),
        .key_valid(key_valid),

        .buffer_out(buffer),
        .buffer_valid(buffer_valid),

        .clk(clk),
        .rst(rst)
    );

    BufferDecode buffer_decode (
        .buffer(buffer),
        .buffer_valid(buffer_valid),

        .buff_value(buff_value),

        .clk(clk),
        .rst(rst)
    );

    Accel accel (
        .image_dim(image_dim),
        .image_depth(image_depth),

        .image_memory_offset(0),
        .filter_memory_offset(0),
        .output_memory_offset(0),

        .filter_halfsize(filter_halfsize),
        .filter_stride(filter_stride),
        .filter_length(filter_length),
        .filter_bias(filter_bias),

        .interface_write_addr(interface_write_addr),
        .interface_write_data(interface_write_data),
        .interface_write_en(interface_write_en),
        .interface_write_sel(interface_write_sel),

        .output_read_data(output_read_data),
        .output_read_valid(output_read_valid),

        .accel_done(),

        .clk(clk),
        .rst(rst | ~accel_active)
    );

    AccelOutputDecode accel_output_decode (
        .read_data(output_read_data),
        .read_valid(output_read_valid),

        .print_char(print_char),
        .print_valid(print_valid),

        .clk(clk),
        .rst(rst)
    );
	 
	 assign leds[3:0] = read_state[3:0];

    always @(posedge clk) begin
        if (rst) begin
            read_state <= 0;
            in_ctr <= 0;
            accel_active <= 0;
        end

        else if (read_state == 0) begin
            if (buffer_valid) begin
                image_dim <= buff_value;
                read_state <= 1;
            end
        end 
        
        else if (read_state == 1) begin
            if (buffer_valid) begin
                image_depth <= buff_value;
                in_ctr_max <= buff_value * image_dim * image_dim;
					 in_ctr <= 0;
                read_state <= 2;
                interface_write_addr <= 0;
            end
        end 
        
        else if (read_state == 2) begin
            if (buffer_valid) begin
                in_ctr <= in_ctr + 1;
                interface_write_sel <= 0; // SEL image
                interface_write_en <= 1;
                interface_write_addr <= interface_write_addr + 1;
                interface_write_data <= buff_value;
					 if (in_ctr == in_ctr_max) begin
						read_state <= 4;
					 end
            end else begin
                interface_write_en <= 0;
            end
        end

        else if (read_state == 3) begin
            if (buffer_valid) begin
                filter_halfsize <= buff_value;
                read_state <= 4;
            end
        end 
        
        
        else if (read_state == 4) begin
            if (buffer_valid) begin
                filter_stride <= buff_value;
                read_state <= 5;
            end
        end 
        
        else if (read_state == 5) begin
            if (buffer_valid) begin
                filter_halfsize <= buff_value;
                read_state <= 6;
            end
        end 
        
        else if (read_state == 6) begin
            if (buffer_valid) begin
                filter_length <= buff_value;
                read_state <= 7;
            end
        end 
        
        else if (read_state == 7) begin
            if (buffer_valid) begin
                filter_bias <= buff_value;
                read_state <= 8;
                interface_write_addr <= 0;
                in_ctr <= filter_length;
            end
        end 
        
        else if (read_state == 8) begin
            if (buffer_valid) begin
                in_ctr <= in_ctr - 1;
                interface_write_sel <= 2'b01; // SEL filter
                interface_write_en <= 1;
                interface_write_addr <= interface_write_addr + 1;
                interface_write_data <= buff_value;
            end else begin
                interface_write_en <= 0;
            end
            if (buffer_valid && in_ctr == 1) begin
                read_state <= 9;
            end
        end

        else if (read_state == 9) begin
            accel_active <= 1;
        end
    end

endmodule
`endif // _include_wrap_accel_
