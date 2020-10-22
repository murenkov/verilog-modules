module event_counter(
    input            CLOCK_50,
    input      [3:0] KEY,
    input      [9:0] SW,

    output reg [6:0] HEX0,
    output reg [9:0] LEDR
);

// Event setter
reg switch_event;
always @(SW) begin
    switch_event <= (SW > 10'd8) && (SW <= 10'd12);
end

// Count button syncroniser
reg [2:0] count_button_sync;
always @(posedge CLOCK_50) begin
    count_button_sync[0] <= KEY[0];
    count_button_sync[1] <= count_button_sync[0];
    count_button_sync[2] <= count_button_sync[1];
end

wire count;
assign count = ~count_button_sync[2] & count_button_sync[1];

// Reset button syncroniser
reg [2:0] reset_button_sync;
always @(posedge CLOCK_50) begin
    reset_button_sync[0] <= KEY[1];
    reset_button_sync[1] <= reset_button_sync[0];
    reset_button_sync[2] <= reset_button_sync[1];
end

wire reset;
assign reset = ~reset_button_sync[2] & reset_button_sync[1];

// Event counter
reg [9:0] counter;
always @(posedge count or posedge reset) begin
    if (reset) counter <= 0;
    else if (switch_event) counter <= counter + 1;
end

// DC-HEX0
always @(*) begin
    case (counter)
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
        4'hc : HEX0 = 7'b1000110;
        4'hd : HEX0 = 7'b0100001;
        4'he : HEX0 = 7'b0000110;
        4'hf : HEX0 = 7'b0001110;

        default : HEX0 = 7'd1111111;
    endcase
end 

always @(*) begin
    LEDR <= SW;
end

endmodule
