module state_machine(
    input CLOCK_50,
    input [3:0] KEY,

    output reg [6:0] HEX0
);

localparam ATHENA = 2'd0;
localparam BRAHMA = 2'd1;
localparam CHRIST = 2'd2;
localparam DEIMOS = 2'd3;

// Button A syncroniser
reg [2:0] button_A_sync;
always @(posedge CLOCK_50) begin
    button_A_sync[0] <= KEY[0];
    button_A_sync[1] <= button_A_sync[0];
    button_A_sync[2] <= button_A_sync[1];
end

wire button_A;
assign button_A = ~button_A_sync[2] & button_A_sync[1];

// Button B syncroniser
reg [2:0] button_B_sync;
always @(posedge CLOCK_50) begin
    button_B_sync[0] <= KEY[1];
    button_B_sync[1] <= button_B_sync[0];
    button_B_sync[2] <= button_B_sync[1];
end

wire button_B;
assign button_B = ~button_B_sync[2] & button_B_sync[1];

// Button A syncroniser
reg [2:0] button_C_sync;
always @(posedge CLOCK_50) begin
    button_C_sync[0] <= KEY[2];
    button_C_sync[1] <= button_C_sync[0];
    button_C_sync[2] <= button_C_sync[1];
end

wire button_C;
assign button_C = ~button_C_sync[2] & button_C_sync[1];

// Reset button syncroniser
reg [2:0] reset_button_sync;
always @(posedge CLOCK_50) begin
    reset_button_sync[0] <= KEY[3];
    reset_button_sync[1] <= reset_button_sync[0];
    reset_button_sync[2] <= reset_button_sync[1];
end

wire reset;
assign reset = ~reset_button_sync[2] & reset_button_sync[1];

// State machine
reg [1:0] state;
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) state <= ATHENA;
    else case (state)
        ATHENA:
            if (button_A) state <= BRAHMA;
            else if (button_B) state <= CHRIST;
        BRAHMA:
            if (button_C) state <= CHRIST;
        CHRIST:
            if (button_B) state <= DEIMOS;
        DEIMOS:
            if (button_A) state <= ATHENA;
            else if (button_C) state <= CHRIST;
    endcase
end

// HEX0
always @(*) begin
    case (state)
        2'b00 : HEX0 = 7'b1000000;
        2'b01 : HEX0 = 7'b1111001;
        2'b10 : HEX0 = 7'b0100100;
        2'b11 : HEX0 = 7'b0110000;

        default : HEX0 = 7'b1111111;
    endcase
end 

endmodule
