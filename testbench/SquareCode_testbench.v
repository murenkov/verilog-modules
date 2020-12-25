/*
* Testbench for SquareCode.v
*/

`timescale 1us/1ns

module SquareCode_testbench();

    reg clock, reset;
    reg enable;
    reg [20:0] half_period;
    reg [15:0] volume;
    wire [15:0] square_wave;

    localparam CLOCK_PERIOD = 0.5;
    localparam PERIOD = 10;

    SquareCode UUT(
        .clock         (clock),
        .reset         (reset),
        .enable        (enable),
        .half_period   (half_period),
        .volume        (volume),
        .square_wave   (square_wave)
    );

    always begin
        #CLOCK_PERIOD;
        clock = ~clock;
    end

    initial begin
        $dumpfile("./SquareCode.vcd");
        $dumpvars(0, SquareCode_testbench);

        clock = 0;
        reset = 0;
        enable = 0;
        half_period = 21'h00000a;
        volume = 16'h00ff;
        #2;

        reset = 1;
        enable = 0;
        half_period = 21'h00000a;
        volume = 16'h00ff;
        #1;

        reset = 0;
        enable = 0;
        half_period = 21'h00000a;
        volume = 16'h00ff;
        #1;

        reset = 0;
        enable = 1;
        half_period = 21'h00000a;
        volume = 16'h00ff;
        #1;

        reset = 0;
        enable = 1;
        half_period = 21'h00000a;
        volume = 16'h00ff;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;

        reset = 0;
        enable = 0;
        half_period = 21'h00000a;
        volume = 16'h00ff;
        #PERIOD;

        $finish;
    end

endmodule
