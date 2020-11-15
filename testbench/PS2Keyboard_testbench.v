/*
* Testbench for PS2Keyboard.v
*/

`timescale 1us/1ns

module PS2Keyboard_testbench();

    reg clock, reset;
    reg ps2_clock, ps2_data;

    wire data_is_valid;
    wire [6:0] HEX0, HEX1;

    localparam clock_period = 0.5;
    localparam PERIOD = 1;
    localparam LONG_PERIOD = 20;
    localparam MEDIUM_PERIOD = 4;

    PS2Keyboard UUT(
        .clock         (clock),
        .reset         (reset),
        .ps2_clock     (ps2_clock),
        .ps2_data      (ps2_data),
        .data_is_valid (data_is_valid),
        .HEX0          (HEX0),
        .HEX1          (HEX1)
    );

    always begin
        #clock_period;
        clock = ~clock;
    end

    always begin
        #MEDIUM_PERIOD;
        ps2_clock = ~ps2_clock;
    end

    initial begin
        $dumpfile("./PS2Keyboard.vcd");
        $dumpvars(0, PS2Keyboard_testbench);

        clock = 0;
        ps2_clock = 0;

        reset = 1;
        ps2_data = 1;
        #PERIOD;
        reset = 0;
        #LONG_PERIOD;

        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #LONG_PERIOD;


        $finish;
    end

endmodule

