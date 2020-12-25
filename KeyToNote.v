/*
* Key to Note module
*
* Take the key code and returns half_period
*/

module KeyToNote(
    input [7:0] data,

    output reg [20:0] half_period
);

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

    localparam NOTE_C  = 19'd95555;
    localparam NOTE_DB = 19'd90192;
    localparam NOTE_D  = 19'd85130;
    localparam NOTE_EB = 19'd80352;
    localparam NOTE_E  = 19'd75842;
    localparam NOTE_F  = 19'd71585;
    localparam NOTE_GB = 19'd67568;
    localparam NOTE_G  = 19'd63775;
    localparam NOTE_AB = 19'd60196;
    localparam NOTE_A  = 19'd56817;
    localparam NOTE_BB = 19'd53628;
    localparam NOTE_B  = 19'd50618; 

    always @(*)
        case (data)
            KEY_Q:           half_period = NOTE_C;
            KEY_W:           half_period = NOTE_DB;
            KEY_E:           half_period = NOTE_D;
            KEY_R:           half_period = NOTE_EB;
            KEY_T:           half_period = NOTE_E;
            KEY_Y:           half_period = NOTE_F;
            KEY_U:           half_period = NOTE_GB;
            KEY_I:           half_period = NOTE_G;
            KEY_O:           half_period = NOTE_AB;
            KEY_P:           half_period = NOTE_A;
            KEY_OPEN_BRACE:  half_period = NOTE_BB;
            KEY_CLOSE_BRACE: half_period = NOTE_B;
        endcase

endmodule

