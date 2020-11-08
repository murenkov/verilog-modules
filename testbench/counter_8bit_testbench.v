/*
* Testbench for counter.v
*/

`timescale 1us/1ns

module counter_8bit_testbench();

    reg         enable;
    reg         clock;
    reg         reset;
    wire  [7:0] counter;

    localparam clock_period = 0.5;
    localparam PERIOD = 1;
    localparam LONG_PERIOD = 300;

    counter_8bit UUT(
        .enable     (enable),
        .clock      (clock),
        .reset      (reset),
        .counter    (counter)
    );

    always begin
        #clock_period;
        clock = ~clock;
    end

    initial begin
        $dumpfile("./counter_8bit.vcd");
        $dumpvars(0, counter_8bit_testbench);

        clock = 0;

        reset = 1;
        enable = 0;
        #PERIOD;

        reset = 0;
        enable = 1;
        #LONG_PERIOD;

        reset = 1;
        enable = 1;
        #PERIOD;

        reset = 0;
        enable = 1;
        #LONG_PERIOD;



        $finish;
    end

endmodule
