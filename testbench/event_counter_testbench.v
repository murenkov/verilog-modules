/*
* Testbench for event_counter.v
*/

`timescale 1us/1ns

module event_counter_testbench();

reg CLOCK_50;
reg [3:0] KEY;
reg [9:0] SW;

wire [6:0] HEX0;
wire [9:0] LEDR;

localparam clock_period = 0.5;
localparam period = 1;

event_counter UUT(
    .CLOCK_50 (CLOCK_50),
    .KEY      (KEY),
    .SW       (SW),
    .HEX0     (HEX0),
    .LEDR     (LEDR)
);

always begin
    #clock_period;
    CLOCK_50 = ~CLOCK_50;
end

initial begin
    $dumpfile("./event_counter.vcd");
    $dumpvars(0, event_counter_testbench);

    CLOCK_50 = 0;
    KEY = 0;
    SW = 0;
    #period;

    KEY[1] = 1;
    #period;
    KEY[1] = 0;
    #period;

    SW = 10'd20;
    #period;
    KEY[0] = 1;
    #period;
    KEY[0] = 0;
    #period;

    SW = 10'd10;
    #period;
    KEY[0] = 1;
    #period;
    KEY[0] = 0;
    #period;

    SW = 10'd12;
    #period;
    KEY[0] = 1;
    #period;
    KEY[0] = 0;
    #period;

    SW = 10'd8;
    #period;
    KEY[0] = 1;
    #period;
    KEY[0] = 0;
    #period;

    $finish;
end

endmodule

