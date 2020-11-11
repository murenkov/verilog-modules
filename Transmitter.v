/*
* Transmitter
*/

module Transmitter(
    input [3:0] data_in,
    input       start,

    output reg busy,
    output reg [6:0] tx
);

    always @(*)
        if (start) begin
            busy <= 1;
            case (data_in)
                4'd0: tx <= 7'b1000000;
                4'd1: tx <= 7'b1111001;
                4'd2: tx <= 7'b0100100;
                4'd3: tx <= 7'b0110000;
                4'd4: tx <= 7'b0011001;
                4'd5: tx <= 7'b0010010;
                4'd6: tx <= 7'b0000010;
                4'd7: tx <= 7'b1111000;
                4'd8: tx <= 7'b0000000;
                4'd9: tx <= 7'b0100000;

                default: tx <= 7'b1111111;
            endcase
            busy <= 0;
        end

endmodule

