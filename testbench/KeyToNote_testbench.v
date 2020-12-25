/*
* Testbench for KeyToNote.v
*/

`timescale 1us/1ns

module KeyToNote_testbench();

    reg [7:0] data;
    wire  [20:0] half_period;

    localparam PERIOD = 1;

    localparam KEY_Q           = 8'h15;
    localparam KEY_W           = 8'h1D;
    localparam KEY_E           = 8'h24;
    localparam KEY_R           = 8'h2D;
    localparam KEY_T           = 8'h2C;
    localparam KEY_Y           = 8'h35;
    localparam KEY_U           = 8'h3C;
    localparam KEY_I           = 8'h43;
    localparam KEY_O           = 8'h44;
    localparam KEY_P           = 8'h4D;
    localparam KEY_OPEN_BRACE  = 8'h54;
    localparam KEY_CLOSE_BRACE = 8'h5B;
    localparam BREAK_CODE      = 8'hF0;

    KeyToNote UUT(
        .data        (data),
        .half_period (half_period)
    );

    initial begin
        $dumpfile("./KeyToNote.vcd");
        $dumpvars(0, KeyToNote_testbench);

        data = KEY_Q;
        #PERIOD;
        
        data = KEY_T;
        #PERIOD;

        data = KEY_U;
        #PERIOD;

        data = KEY_E;
        #PERIOD;
    end

endmodule
