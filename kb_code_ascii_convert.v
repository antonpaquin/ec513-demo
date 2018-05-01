`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BU
// Engineer: Josh Wildey
// 
// Create Date:    02:13:26 04/11/2018 
// Module Name:    kb_code_ascii_convert 
// Project Name: Lab 2 - Peripheral and Processor Integration with I/O
// Target Devices: Nexys3 Spartan 6
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module kb_code_ascii_convert(
	input  wire [7:0] kb_code,
	input  wire       caps_lock,
	input  wire       shift,
   output reg  [7:0] ascii
   );

	always @ (*) begin
		case (kb_code)
			// ` or ~
			8'h0E: begin
				if (shift) ascii <= 8'h7E;
				else ascii <= 8'h60;
			end
			// 1 or !
			8'h16: begin
				if (shift) ascii <= 8'h21;
				else ascii <= 8'h31;
			end
			// 2 or @
			8'h1E: begin
				if (shift) ascii <= 8'h40;
				else ascii <= 8'h32;
			end
			// 3 or #
			8'h26: begin
				if (shift) ascii <= 8'h23;
				else ascii <= 8'h33;
			end
			// 4 or $
			8'h25: begin
				if (shift) ascii <= 8'h24;
				else ascii <= 8'h34;
			end
			// 5 or %
			8'h2E: begin
				if (shift) ascii <= 8'h25;
				else ascii <= 8'h35;
			end
			// 6 or ^
			8'h36: begin
				if (shift) ascii <= 8'h5E;
				else ascii <= 8'h36;
			end
			// 7 or &
			8'h3D: begin
				if (shift) ascii <= 8'h26;
				else ascii <= 8'h37;
			end
			// 8 or *
			8'h3E: begin
				if (shift) ascii <= 8'h2A;
				else ascii <= 8'h38;
			end
			// 9 or (
			8'h46: begin
				if (shift) ascii <= 8'h28;
				else ascii <= 8'h39;
			end
			// 0 or )
			8'h45: begin
				if (shift) ascii <= 8'h29;
				else ascii <= 8'h30;
			end
			// - or _
			8'h4E: begin
				if (shift) ascii <= 8'h5F;
				else ascii <= 8'h2D;
			end
			// = or +
			8'h55: begin
				if (shift) ascii <= 8'h2B;
				else ascii <= 8'h3D;
			end
			// Backspace
			8'h66: ascii <= 8'h08;
			// tab
			8'h55: begin
				if (shift) ascii <= 8'h08;
				else ascii <= 8'h09;
			end
			// q or Q
			8'h15: begin
				if (shift || caps_lock) ascii <= 8'h51;
				else ascii <= 8'h71;
			end
			// w or W
			8'h1D: begin
				if (shift || caps_lock) ascii <= 8'h57;
				else ascii <= 8'h77;
			end
			// e or E
			8'h24: begin
				if (shift || caps_lock) ascii <= 8'h45;
				else ascii <= 8'h65;
			end
			// r or R
			8'h2D: begin
				if (shift || caps_lock) ascii <= 8'h52;
				else ascii <= 8'h72;
			end
			// t or T
			8'h2C: begin
				if (shift || caps_lock) ascii <= 8'h54;
				else ascii <= 8'h74;
			end
			// y or Y
			8'h35: begin
				if (shift || caps_lock) ascii <= 8'h59;
				else ascii <= 8'h79;
			end
			// u or U
			8'h3C: begin
				if (shift || caps_lock) ascii <= 8'h55;
				else ascii <= 8'h75;
			end
			// i or I
			8'h43: begin
				if (shift || caps_lock) ascii <= 8'h49;
				else ascii <= 8'h69;
			end
			// o or O
			8'h44: begin
				if (shift || caps_lock) ascii <= 8'h4F;
				else ascii <= 8'h6F;
			end
			// p or P
			8'h4D: begin
				if (shift || caps_lock) ascii <= 8'h50;
				else ascii <= 8'h70;
			end
			// [ or {
			8'h54: begin
				if (shift || caps_lock) ascii <= 8'h7B;
				else ascii <= 8'h5B;
			end
			// ] or }
			8'h5B: begin
				if (shift || caps_lock) ascii <= 8'h7D;
				else ascii <= 8'h5D;
			end
			// \ or |
			8'h5D: begin
				if (shift || caps_lock) ascii <= 8'h7C;
				else ascii <= 8'h5C;
			end
			// a or A
			8'h1C: begin
				if (shift || caps_lock) ascii <= 8'h41;
				else ascii <= 8'h61;
			end
			// s or S
			8'h1B: begin
				if (shift || caps_lock) ascii <= 8'h53;
				else ascii <= 8'h73;
			end
			// d or D
			8'h23: begin
				if (shift || caps_lock) ascii <= 8'h44;
				else ascii <= 8'h64;
			end
			// f or F
			8'h2B: begin
				if (shift || caps_lock) ascii <= 8'h46;
				else ascii <= 8'h66;
			end
			// g or G
			8'h34: begin
				if (shift || caps_lock) ascii <= 8'h47;
				else ascii <= 8'h67;
			end
			// h or H
			8'h33: begin
				if (shift || caps_lock) ascii <= 8'h48;
				else ascii <= 8'h68;
			end
			// j or J
			8'h3B: begin
				if (shift || caps_lock) ascii <= 8'h4A;
				else ascii <= 8'h6A;
			end
			// k or K
			8'h42: begin
				if (shift || caps_lock) ascii <= 8'h4B;
				else ascii <= 8'h6B;
			end
			// l or L
			8'h4B: begin
				if (shift || caps_lock) ascii <= 8'h4C;
				else ascii <= 8'h6C;
			end
			// ; or :
			8'h4C: begin
				if (shift || caps_lock) ascii <= 8'h3A;
				else ascii <= 8'h3B;
			end
			// ' or "
			8'h52: begin
				if (shift || caps_lock) ascii <= 8'h22;
				else ascii <= 8'h27;
			end
			// newline
			8'h5A: ascii <= 8'h0A;
			// z or Z
			8'h1A: begin
				if (shift || caps_lock) ascii <= 8'h5A;
				else ascii <= 8'h7A;
			end
			// x or X
			8'h22: begin
				if (shift || caps_lock) ascii <= 8'h58;
				else ascii <= 8'h78;
			end
			// c or C
			8'h21: begin
				if (shift || caps_lock) ascii <= 8'h43;
				else ascii <= 8'h63;
			end
			// v or V
			8'h2A: begin
				if (shift || caps_lock) ascii <= 8'h56;
				else ascii <= 8'h76;
			end
			// b or B
			8'h32: begin
				if (shift || caps_lock) ascii <= 8'h42;
				else ascii <= 8'h62;
			end
			// n or N
			8'h31: begin
				if (shift || caps_lock) ascii <= 8'h4E;
				else ascii <= 8'h6E;
			end
			// m or M
			8'h3A: begin
				if (shift || caps_lock) ascii <= 8'h4D;
				else ascii <= 8'h6D;
			end
			// , or <
			8'h41: begin
				if (shift || caps_lock) ascii <= 8'h3C;
				else ascii <= 8'h2C;
			end
			// . or >
			8'h49: begin
				if (shift || caps_lock) ascii <= 8'h3E;
				else ascii <= 8'h2E;
			end
			// / or ?
			8'h4A: begin
				if (shift || caps_lock) ascii <= 8'h3F;
				else ascii <= 8'h2F;
			end
			// space
			8'h29: ascii <= 8'h20;
			default: ascii <= kb_code;
		endcase
	end

endmodule
