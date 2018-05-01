`ifndef _include_kb_buffer_decode_
`define _include_kb_buffer_decode_

module BufferDecode (
        input  wire [31:0] buffer,
        input  wire        buffer_valid,

        output wire [17:0] buff_value,

        input wire         clk,
        input wire         rst
    );

    assign buff_value = (
        (1000 * (buffer[31:24] - "0")) + 
        (100  * (buffer[23:16] - "0")) + 
        (10   * (buffer[15: 8] - "0")) +
        (1    * (buffer[ 7: 0] - "0"))
    );

endmodule
`endif // _include_kb_buffer_decode_
