/*
* Testbench for Transmitter.v
*/

`timescale 1us/1ns

module Transmitter_testbench();

    reg [3:0] data_in;
    reg       start;

    wire busy;
    wire [6:0] tx;

    localparam PERIOD = 1;

    Transmitter UUT(
        .data_in    (data_in),
        .start      (start),
        .busy       (busy),
        .tx         (tx)
    );

    initial begin
        $dumpfile("./Transmitter.vcd");
        $dumpvars(0, Transmitter_testbench);

        data_in = 5;
        start = 1;
        #PERIOD;

        data_in = 8;
        start = 1;
        #PERIOD;

        data_in = 8;
        start = 0;
        #PERIOD;

        data_in = 0;
        start = 1;
        #PERIOD;

        data_in = 9;
        start = 1;
        #PERIOD;

        data_in = 8;
        start = 0;
        #PERIOD;

        data_in = 1;
        start = 1;
        #PERIOD;

    end

endmodule

