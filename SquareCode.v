module SquareCode(
    input clock, reset,
    input enable,
    input [20:0] half_period, 
    input [15:0] volume,

    output [15:0] square_wave,
    output reg wr
);

    reg [20:0] counter;
    reg square;

    always @(posedge clock or posedge reset)
        if (reset)
            counter <= 21'd0;
        else if ((counter >= half_period) || ~enable)
            counter <= 21'd0;
        else counter <= counter + 1;

    always @(posedge clock or posedge reset)
        if (reset)
            wr <= 1'b0;
        else if ((counter >= half_period) && enable)
            wr <= 1'b1;
        else
            wr <= 1'b0;

    always @(posedge clock or posedge reset)
        if (reset)
            square <= 1'b0;
        else if (enable)
            if (counter >= half_period)
                square <= ~square;

    assign square_wave = (square && enable) ? volume : 16'd0;

endmodule

