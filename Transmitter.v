/*
* Transmitter
*/

module Transmitter(
    input [3:0] data_in,
    input       start,

    output           busy,
    output reg [6:0] tx
);

    assign busy = ~start;

    always @(*)
        if (start) begin
            case (data_in)
                4'h0: tx = 7'b1000000;
                4'h1: tx = 7'b1111001;
                4'h2: tx = 7'b0100100;
                4'h3: tx = 7'b0110000;
                4'h4: tx = 7'b0011001;
                4'h5: tx = 7'b0010010;
                4'h6: tx = 7'b0000010;
                4'h7: tx = 7'b1111000;
                4'h8: tx = 7'b0000000;
                4'h9: tx = 7'b0100000;
                4'hA: tx = 7'b0001000;
                4'hB: tx = 7'b0000011;
                4'hC: tx = 7'b1000110;
                4'hD: tx = 7'b0100001;
                4'hE: tx = 7'b0000110;
                4'hF: tx = 7'b0001110;

                default: tx = 7'b1111111;
            endcase
        end

endmodule

