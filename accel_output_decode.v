`ifndef _include_accel_output_decode_
`define _include_accel_output_decode_

module AccelOutputDecode (
        input wire [17:0] read_data,
        input wire read_valid,

        output reg [7:0] print_char,
        output reg       print_valid,

        input wire clk,
        input wire rst
    );

    reg [2:0] digit_ctr; 
    reg [17:0] hold_read;

    always @(posedge clk) begin
        if (rst) begin
            digit_ctr <= 0;
            hold_read <= 0;
            print_valid <= 0;
        end else if (read_valid) begin
            hold_read <= read_data;
            digit_ctr <= 6;
            print_valid <= 0;
            print_char <= 0;
        end else if (digit_ctr == 6) begin
            print_char <= (hold_read / 1000);
            print_valid <= 1;
            digit_ctr <= 5;
        end else if (digit_ctr == 5) begin
            print_char <= ((hold_read % 1000) / 100);
            print_valid <= 1;
            digit_ctr <= 4;
        end else if (digit_ctr == 4) begin
            print_char <= ((hold_read % 100) / 10);
            print_valid <= 1;
            digit_ctr <= 3;
        end else if (digit_ctr == 3) begin
            print_char <= (hold_read % 10);
            print_valid <= 1;
            digit_ctr <= 2;
        end else if (digit_ctr == 2) begin
            print_char <= 10;
            print_valid <= 1;
            digit_ctr <= 1;
        end else if (digit_ctr == 1) begin
            print_char <= 0;
            print_valid <= 0;
            digit_ctr <= 0;
        end else if (digit_ctr == 0) begin
            print_valid <= 0;
        end
    end
endmodule
`endif // _include_accel_output_decode_
