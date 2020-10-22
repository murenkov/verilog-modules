module state_machine(
    input CLOCK_50,
    input reset,
    input [3:0] KEY,

    output reg [6:0] HEX0
);

localparam ATHENA = 2'b00;
localparam BRAHMA = 2'b01;
localparam CHRIST = 2'b10;
localparam DEIMOS = 2'b11;

reg [1:0] state;

always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) state <= ATHENA;
    else case (state)
        ATHENA:
            if (KEY[0]) state <= BRAHMA;
            else if (KEY[1]) state <= CHRIST;
        BRAHMA:
            if (KEY[2]) state <= CHRIST;
        CHRIST:
            if (KEY[1]) state <= DEIMOS;
        DEIMOS:
            if (KEY[0]) state <= ATHENA;
            else if (KEY[2]) state <= CHRIST;
    endcase
end

// DC
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

