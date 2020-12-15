module lab6(
    input CLOCK_50,
    input [3:0] KEY,

    input ps2_clock, ps2_data,

    output valid_data,
    output [7:0] data,
    output reg [6:0] HEX0, HEX1
);

    wire reset;
    assign reset = KEY[0];
    wire [13:0] hex_out;

    localparam KEY_Q = 8'h15;
    localparam KEY_W = 8'h1D;
    localparam KEY_E = 8'h24;
    localparam KEY_R = 8'h2D;
    localparam KEY_T = 8'h2C;
    localparam KEY_Y = 8'h35;

    always @(posedge CLOCK_50)
        case (data)
            KEY_Q: {HEX1, HEX0} <= hex_out;
            KEY_W: {HEX1, HEX0} <= hex_out;
            KEY_E: {HEX1, HEX0} <= hex_out;
            KEY_R: {HEX1, HEX0} <= hex_out;
            KEY_T: {HEX1, HEX0} <= hex_out;
            KEY_Y: {HEX1, HEX0} <= hex_out;

            default: {HEX1, HEX0} <= 14'h3FFF;
        endcase

    ps2_keyboard ps2(
        .areset     (reset),
        .clk_50     (CLOCK_50),
        .ps2_clk    (ps2_clock),
        .ps2_dat    (ps2_data),
        .valid_data (valid_data),
        .data       (data)
    );

    SevenSegmentDisplay SSeg0(
        .data_in (data[3:0]),
        .hex_out (hex_out[6:0])
    );

    SevenSegmentDisplay SSeg1(
        .data_in (data[7:4]),
        .hex_out (hex_out[13:7])
    );

endmodule

