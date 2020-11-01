module muxer(
    input      [9:0] SW,

    output reg [7:0] HEX0,
    output reg [3:0] mux_out
);

// DC1
// Count number of "11" combinations
reg [3:0] dc1_out;
always @(*) begin
    case (SW[3:0])
        4'b0011 : dc1_out = 4'd1;
        4'b0110 : dc1_out = 4'd1;
        4'b0111 : dc1_out = 4'd1;
        4'b1011 : dc1_out = 4'd1;
        4'b1100 : dc1_out = 4'd1;
        4'b1101 : dc1_out = 4'd1;
        4'b1110 : dc1_out = 4'd1;
        4'b1111 : dc1_out = 4'd2;

        default : dc1_out = 4'd0;
    endcase
end

// DC2
// Do logic AND with 0101;
reg [3:0] dc2_out;
always @(*)
begin
    case (SW[7:4])
        4'b0000 : dc2_out = 4'b0000;
        4'b0001 : dc2_out = 4'b0001;
        4'b0010 : dc2_out = 4'b0000;
        4'b0011 : dc2_out = 4'b0001;
        4'b0100 : dc2_out = 4'b0100;
        4'b0101 : dc2_out = 4'b0101;
        4'b0110 : dc2_out = 4'b0100;
        4'b0111 : dc2_out = 4'b0101;
        4'b1000 : dc2_out = 4'b0000;
        4'b1001 : dc2_out = 4'b0001;
        4'b1010 : dc2_out = 4'b0000;
        4'b1011 : dc2_out = 4'b0001;
        4'b1100 : dc2_out = 4'b0100;
        4'b1101 : dc2_out = 4'b0101;
        4'b1110 : dc2_out = 4'b0100;
        4'b1111 : dc2_out = 4'b0101;

        default: dc2_out = 4'b0000;
    endcase
end

// f
wire f_out;
assign f_out = SW[0] & SW[1] & SW[2] ^ SW[3];

// MUX
// reg [3:0] mux_out;

always @(*)
begin
    case (SW[9:8])
        2'b00 : mux_out = dc1_out;
        2'b01 : mux_out = dc2_out;
        2'b10 : mux_out = f_out;
        
        default : mux_out = 4'd0;
    endcase
end

// DC-HEX
always @(*)
begin
    case (mux_out)
        4'h0 : HEX0 = 7'b1000000;
        4'h1 : HEX0 = 7'b1111001;
        4'h2 : HEX0 = 7'b0100100;
        4'h3 : HEX0 = 7'b0110000;
        4'h4 : HEX0 = 7'b0011001;
        4'h5 : HEX0 = 7'b0010010;
        4'h6 : HEX0 = 7'b0000010;
        4'h7 : HEX0 = 7'b1111000;
        4'h8 : HEX0 = 7'b0000000;
        4'h9 : HEX0 = 7'b0010000;
        4'ha : HEX0 = 7'b0001000;
        4'hb : HEX0 = 7'b0000011;
        4'hc : HEX0 = 7'b0111001;
        4'hd : HEX0 = 7'b0100001;
        4'he : HEX0 = 7'b0000110;
        4'hf : HEX0 = 7'b0001110;

        default: HEX0 = 7'b1111111;
    endcase
end

endmodule
