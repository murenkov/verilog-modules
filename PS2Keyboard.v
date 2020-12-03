/*
* PS/2 Keyboard Controller
*/

module PS2Keyboard(
    input clock, reset,
    input ps2_clock, ps2_data,

    output reg data_is_valid,
    output [6:0] HEX0, HEX1
);

    // Define clock signal of PS/2 Keyboard
    reg [9:0] ps2_clock_detect;
    wire ps2_clock_negedge;
    always @(posedge clock or posedge reset)
        // ps2_clock_detect <= (reset) ? 10'd0 : {ps2_clock, ps2_clock_detect[9:1]};
        if (reset)
            ps2_clock_detect <= 10'd0;
        else
            ps2_clock_detect <= {ps2_clock, ps2_clock_detect[9:1]};

    assign ps2_clock_negedge = &ps2_clock_detect[4:0] && &(~ps2_clock_detect[9:5]);

    // State handler
    localparam IDLE                   = 2'b00;
    localparam RECEIVE_DATA           = 2'b01;
    localparam CHECK_PARITY_STOP_BITS = 2'b10;

    reg [1:0] state;
    always @(posedge clock or posedge reset)
        if (reset)
            state <= IDLE;
        else if (ps2_clock_negedge)
            case (state)
                IDLE:
                    if (!ps2_data)
                        state = RECEIVE_DATA;

                RECEIVE_DATA:
                    if (bits_counter == 8)
                        state = CHECK_PARITY_STOP_BITS;

                CHECK_PARITY_STOP_BITS:
                    state = IDLE;

                default:
                    state = IDLE;
            endcase

    // Received data shift register
    reg [8:0] shift_reg;
    always @(posedge clock or posedge reset)
        if (reset)
            shift_reg <= 9'b0;
        else if (ps2_clock_negedge)
            if (state == RECEIVE_DATA)
                shift_reg <= {ps2_data, shift_reg[8:1]};

    // Received bits counter
    reg [3:0] bits_counter;
    always @(posedge clock or posedge reset)
        if (reset)
            bits_counter <= 4'b0;
        else if (ps2_clock_negedge)
            if (state == RECEIVE_DATA)
                bits_counter <= bits_counter + 1;
            else
                bits_counter <= 0;

    // Stop bits parity checker
    function check_parity;
        input [7:0] data;
        check_parity = ~^data;
    endfunction

    always @(posedge clock or posedge reset)
        if (reset)
            data_is_valid <= 0;
        else if (ps2_clock_negedge)
            data_is_valid <= (ps2_data && check_parity(shift_reg[7:0]) == shift_reg[8] && state == CHECK_PARITY_STOP_BITS) ? 1 : 0;
            // if (ps2_data && check_parity(shift_reg[7:0]) == shift_reg[8] && state == CHECK_PARITY_STOP_BITS))
            //     data_is_valid <= 1;
            // else
            //     data_is_valid <= 0;

    localparam KEY_Q = 8'h15;
    localparam KEY_W = 8'h1D;
    localparam KEY_E = 8'h24;
    localparam KEY_R = 8'h2D;
    localparam KEY_T = 8'h2C;
    localparam KEY_Y = 8'h35;

    wire [13:0] hex_out;

    /*
    always @(*)
        if (shift_reg == KEY_Q ||
            shift_reg == KEY_W ||
            shift_reg == KEY_E ||
            shift_reg == KEY_R ||
            shift_reg == KEY_T ||
            shift_reg == KEY_Y) 
            {HEX1, HEX0} <= hex_out;
    */
    
    assign {HEX1, HEX0} = (shift_reg == KEY_Q ||
                           shift_reg == KEY_W ||
                           shift_reg == KEY_E ||
                           shift_reg == KEY_R ||
                           shift_reg == KEY_T ||
                           shift_reg == KEY_Y) ? hex_out : 14'h3FFF;
            

    SevenSegmentDisplay SevenSeg0(
        .data_in (shift_reg[3:0]),
        .hex_out (hex_out[6:0])
    );

    SevenSegmentDisplay SevenSeg1(
        .data_in (shift_reg[7:4]),
        .hex_out (hex_out[13:7])
    );

endmodule

