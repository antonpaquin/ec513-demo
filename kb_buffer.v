`ifndef _include_kb_buffer_
`define _include_kb_buffer_

`define KEY_LINEFEED 8'b00001101

module KbBuffer (
        input  wire [  7:0] key,
        input  wire         key_valid,
        output reg  [31:0] buffer_out,
        output reg          buffer_valid,

        input wire          clk,
        input wire          rst
    );

    integer ii;

    reg [1:0] buffer_pos;
    reg [7:0] buffer [3:0];

    always @(posedge clk) begin
        if (rst) begin
            for (ii=0; ii<4; ii=ii+1) begin
                buffer[ii] <= 0;
            end

            buffer_valid <= 0;
            buffer_pos <= 0;
        end else if (key_valid) begin
            if (key == `KEY_LINEFEED) begin
                buffer_pos <= 0;
                buffer_valid <= 1;
                buffer_out <= {buffer[0], buffer[1], buffer[2], buffer[3]};
            end else begin
                buffer[buffer_pos] <= key;
                buffer_pos <= buffer_pos + 1;
                buffer_valid <= 0;
            end
        end else begin
            buffer_valid <= 0;
        end
    end

endmodule
`endif // _include_kb_buffer_

