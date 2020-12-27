module Audio(
    input CLOCK_50,
    input [3:0] KEY,

    input ps2_clock,
    input ps2_data,

    output reg [6:0] HEX0, HEX1,

    output [15:0] square_wave,
    output wr
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

    localparam VOLUME_DELTA = 15'h1FFF;

    localparam IDLE = 1'b0;
    localparam KEY_PRESSED = 1'b1;

    wire [20:0] half_period;
    wire [7:0] data;
    wire [13:0] hex_out;
    reg [15:0] volume;
    reg enable;
    wire valid_data;
    reg valid_prev;
    reg state;

    // Next-state logic
    always @(*)
        if (data == 8'hF0)
            valid_prev = 1'b1;

    // State machine
    always @(CLOCK_50)
        if (reset)
            state <= IDLE;
        else case (state)
            IDLE:
                if (valid_data && data != 8'hF0)
                    state <= KEY_PRESSED;

            KEY_PRESSED:
                if (valid_prev && valid_data) begin
                    state = IDLE;
                    valid_prev = 1'b0;
                end
        endcase

    always @(posedge valid_data)
        case (state)
            IDLE:
                enable = 1'b0;
            KEY_PRESSED:
                if (data != 8'hF0)
                    enable = 1'b1;
        endcase

    always @(enable)
        if (enable)
            case (data)
                KEY_Q:           {HEX1, HEX0} <= hex_out;
                KEY_W:           {HEX1, HEX0} <= hex_out;
                KEY_E:           {HEX1, HEX0} <= hex_out;
                KEY_R:           {HEX1, HEX0} <= hex_out;
                KEY_T:           {HEX1, HEX0} <= hex_out;
                KEY_Y:           {HEX1, HEX0} <= hex_out;
                KEY_U:           {HEX1, HEX0} <= hex_out;
                KEY_I:           {HEX1, HEX0} <= hex_out;
                KEY_O:           {HEX1, HEX0} <= hex_out;
                KEY_P:           {HEX1, HEX0} <= hex_out;
                KEY_OPEN_BRACE:  {HEX1, HEX0} <= hex_out;
                KEY_CLOSE_BRACE: {HEX1, HEX0} <= hex_out;

                default: {HEX1, HEX0} <= 14'h3FFF;
            endcase
        else
            {HEX1, HEX0} <= 14'h3FFF;


    // Reset button syncroniser
    reg [2:0] reset_button_sync;
    always @(posedge CLOCK_50) begin
        reset_button_sync[0] <= KEY[0];
        reset_button_sync[1] <= reset_button_sync[0];
        reset_button_sync[2] <= reset_button_sync[1];
    end

    wire reset;
    assign reset = ~reset_button_sync[2] & reset_button_sync[1];

    // Volume Plus button syncroniser
    reg [2:0] volume_plus_button_sync;
    always @(posedge CLOCK_50) begin
        volume_plus_button_sync[0] <= KEY[1];
        volume_plus_button_sync[1] <= volume_plus_button_sync[0];
        volume_plus_button_sync[2] <= volume_plus_button_sync[1];
    end

    wire volume_plus;
    assign volume_plus = ~volume_plus_button_sync[2] & volume_plus_button_sync[1];

    // Volume Minus button syncroniser
    reg [2:0] volume_minus_button_sync;
    always @(posedge CLOCK_50) begin
        volume_minus_button_sync[0] <= KEY[2];
        volume_minus_button_sync[1] <= volume_minus_button_sync[0];
        volume_minus_button_sync[2] <= volume_minus_button_sync[1];
    end

    wire volume_minus;
    assign volume_minus = ~volume_minus_button_sync[2] & volume_minus_button_sync[1];

    // Volume Controller
    always @(posedge CLOCK_50 or posedge reset)
        if (reset)
            volume <= 15'h7FFF;
        else begin
            if (volume_plus)
                volume <= volume + VOLUME_DELTA;
            if (volume_minus)
                volume <= volume - VOLUME_DELTA;
        end
    
    ps2_keyboard PS2Keyboard(
        .clock      (CLOCK_50),
        .reset      (reset),
        .ps2_clk    (ps2_clock),
        .ps2_dat    (ps2_data),
        .data       (data),
        .valid_data (valid_data)
    );

    SquareCode SquareCode(
        .clock       (CLOCK_50),
        .reset       (reset),
        .enable      (enable),
        .half_period (half_period),
        .volume      (volume),
        .square_wave (square_wave),
        .wr          (wr)
    );

    KeyToNote KeyToNote(
        .data        (data),
        .half_period (half_period)
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

