/*
* Testbench for FIFO.v
*/

`timescale 1us/1ns

module FIFO_testbench();

    reg clock, reset;
    reg write_enable, read_enable;
    reg [WORD_SIZE-1:0] data_in;

    wire full, empty;
    wire [WORD_SIZE-1:0] data_out;

    localparam WORD_SIZE = 4;

    localparam clock_period = 0.5;
    localparam PERIOD = 1;

    FIFO UUT(
        .clock        (clock),
        .reset        (reset),
        .write_enable (write_enable),
        .read_enable  (read_enable),
        .full         (full),
        .empty        (empty),
        .data_in      (data_in),
        .data_out     (data_out)
    );

    always begin
        #clock_period;
        clock = ~clock;
    end

    initial begin
        $dumpfile("./FIFO.vcd");
        $dumpvars(0, FIFO_testbench);

        clock = 0;

        // 1st clock signal
        // Reset
        reset = 1;
        data_in = 0;
        write_enable = 0;
        read_enable = 0;
        #PERIOD

        // 2nd clock signal
        // Write
        reset = 0;
        data_in = 1;
        write_enable = 1;
        read_enable = 0;
        #PERIOD

        // 3rd clock signal
        // Read
        reset = 0;
        data_in = 0;
        write_enable = 0;
        read_enable = 1;
        #PERIOD

        // 4th clock signal
        // Write
        reset = 0;
        data_in = 2;
        write_enable = 1;
        read_enable = 0;
        #PERIOD

        // 5th clock signal
        // Write
        reset = 0;
        data_in = 3;
        write_enable = 1;
        read_enable = 0;
        #PERIOD

        // 6th clock signal
        // Write and read simultaneously
        reset = 0;
        data_in = 4;
        write_enable = 1;
        read_enable = 1;
        #PERIOD

        // 7th clock signal
        // Read
        reset = 0;
        data_in = 0;
        write_enable = 0;
        read_enable = 1;
        #PERIOD

        // 5th clock signal
        // Read
        reset = 0;
        data_in = 0;
        write_enable = 0;
        read_enable = 1;
        #PERIOD

        $finish;
    end

endmodule
