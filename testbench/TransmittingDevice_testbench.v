/*
* Testbench for TransmittingDevice.v
*/

`timescale 1us/1ns

module TransmittingDevice_testbench();

    reg clock;
    reg [3:0] KEY;
    reg [9:0] queue_write_enable;

    wire [9:0] queue_is_full;
    wire [6:0] HEX0;

    localparam WORD_SIZE = 4;

    localparam CLOCK_PERIOD = 0.5;
    localparam LONG_PERIOD = 20;
    localparam PERIOD = 1;

    TransmittingDevice UUT(
        .CLOCK_50 (clock),
        .KEY      (KEY),
        .SW       (queue_write_enable),
        .LEDR     (queue_is_full),
        .HEX0     (HEX0)
    );

    always begin
        #CLOCK_PERIOD;
        clock = ~clock;
    end

    initial begin
        $dumpfile("./TransmittingDevice.vcd");
        $dumpvars(0, TransmittingDevice_testbench);
        
        clock = 0;
        queue_write_enable = 1;
        KEY = 4'b0000;
        #PERIOD;
        KEY = 4'b0001;
        #PERIOD;
        KEY = 4'b0000;
        #PERIOD;
        KEY = 4'b0010;
        #PERIOD;
        KEY = 4'b0000;
        #PERIOD;
        KEY = 4'b0010;
        #PERIOD;
        KEY = 4'b0000;
        #PERIOD;
        KEY = 4'b0010;
        #PERIOD;
        KEY = 4'b0000;
        #LONG_PERIOD;
        #LONG_PERIOD;
        #LONG_PERIOD;
        #LONG_PERIOD;
        #LONG_PERIOD;
        

        $finish;
    end

endmodule

