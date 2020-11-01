/*
* Testbench for stopwatch.v
*
* WARNING: Output .vcd file has huge size (~800 MB)
*/

`timescale 1us/1ns

module stopwatch_testbench();

reg CLOCK_50;
reg [3:0] KEY;
reg [9:0] SW;

wire [6:0] HEX0, HEX1, HEX2, HEX3;

localparam clock_period = 0.5;
localparam period = 500*1000;

stopwatch UUT(
    .CLOCK_50 (CLOCK_50),
    .KEY      (KEY),
    .SW       (SW),
    .HEX0     (HEX0),
    .HEX1     (HEX1),
    .HEX2     (HEX2),
    .HEX3     (HEX3)
);


always begin
    #clock_period;
    CLOCK_50 = ~CLOCK_50;
end

initial begin
    $dumpfile("./stopwatch.vcd");
    $dumpvars(0, stopwatch_testbench);

    CLOCK_50 = 0;
    KEY = 0;
    SW = 0;
    #period;
    
    KEY[1] = 1;
    #period;
    KEY[1] = 0;
    #period;
    #period;

    KEY[0] = 1;
    #period;
    KEY[0] = 0;
    #period;
    #period;
    #period;
    #period;
    #period;
    #period;

    SW[0] = 1;
    #period;
    #period;
    #period;
    #period;
    #period;
    #period;

    SW[0] = 0;
    #period;
    #period;
    #period;
    #period;
    #period;
    #period;

    KEY[0] = 1;
    #period;
    KEY[0] = 0;
    #period;
    #period;
    #period;
    #period;
    #period;
    #period;
    KEY[1] = 1;
    #period;
    KEY[1] = 0;
    #period;
    #period;
    #period;
    #period;
    #period;
    #period;


    $finish;
end

endmodule
