/* Stopwatch module
* Standard workmode (SW[0] == 0) is "tens of seconds -- seconds -- tenth of seconds -- hundredth of seconds"
* When SW[0] == 1 stopwatch toggles to low accurancy mode 
* "thousands of seconds -- hundreds of seconds -- tens of seconds -- seconds"
*
* SW[0] -- low/high accurancy toggle
* KEY[0] -- start/stop button
* KEY[1] -- reset button
*/
module stopwatch(
    input            CLOCK_50,
    input      [3:0] KEY,
    input      [9:0] SW,

    output reg [6:0] HEX0, HEX1, HEX2, HEX3
);


// Start-stop button syncroniser
reg [2:0] start_stop_button_sync;
always @(posedge CLOCK_50) begin
    start_stop_button_sync[0] <= KEY[0];
    start_stop_button_sync[1] <= start_stop_button_sync[0];
    start_stop_button_sync[2] <= start_stop_button_sync[1];
end

wire start_stop_was_pressed;
assign start_stop_was_pressed = ~start_stop_button_sync[2] & start_stop_button_sync[1];

// Reset button syncroniser
reg [2:0] reset_button_sync;
always @(posedge CLOCK_50) begin
    reset_button_sync[0] <= KEY[1];
    reset_button_sync[1] <= reset_button_sync[0];
    reset_button_sync[2] <= reset_button_sync[1];
end

wire reset;
assign reset = ~reset_button_sync[2] & reset_button_sync[1];

// Device running singnal
reg device_running = 1'd0;
always @(posedge CLOCK_50 posedge start_stop_was_pressed) begin
    device_running <= ~device_running;
end

// Counter
reg [16:0] pulse_counter = 17'd0;
wire hundredth_of_second_passed = (pulse_counter == 17'd2599999);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) pulse_counter <= 0;
    else if (device_running | hundredth_of_second_passed)
        if (hundredth_of_second_passed) pulse_counter <= 0;
        else pulse_counter <= pulse_counter + 1;
end

// Hundredth counter
reg [3:0] hundredth_counter = 4'd0;
wire tenth_of_second_passed = (hundreds_counter == 4'd9 & hundreds_of_second_passed);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) hundredth_counter <= 0;
    else if (hundredth_of_second_passed)
        if (tenth_of_second_passed) hundredth_counter <= 0;
        else hundredth_counter <= hundredth_counter + 1;
end

// Tenth counter
reg [3:0] tenth_counter = 4'd0;
wire second_passed = (tenth_counter == 4'd9 & tenth_of_second_passed);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) tenth_counter <= 0;
    else if (tenth_of_second_passed)
        if (second_passed) tenth_counter <= 0;
        else tenth_counter <= tenth_counter + 1;
end

// Seconds counter
reg [3:0] seconds_counter = 4'd0;
wire ten_passed = (seconds_counter == 4'd9 & second_passed);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) seconds_counter <= 0;
    else if (second_passed)
        if (ten_passed) seconds_counter <= 0;
        else seconds_counter <= seconds_counter + 1;
end

// Tens counter
reg [3:0] tens_counter = 4'd0;
wire hundred_passed = (tens_counter == 4'd9 & ten_passed);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) tens_counter <= 0;
    else if (ten_passed)
        if (hundred_passed) tens_counter <= 0;
        else tens_counter <= tens_counter + 1;
end

// Hundreds counter
reg [3:0] hundrends_counter = 4'd0;
wire thousand_passed = (hundreds_counter == 4'd9 & hundred_passed);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) hundreds_counter <= 0;
    else if (hundred_passed)
        if (thousand_passed) hundreds_counter <= 0;
        else hundreds_counter <= hundreds_counter + 1;
end

// Thousands counter
reg [3:0] thousand_counter = 4'd0;
wire ten_thousands_passed = (thousands_counter == 4'd9 & thousand_passed);
always @(posedge CLOCK_50 or posedge reset) begin
    if (reset) thousands_counter <= 0;
    else if (thousand_passed)
        if (ten_thousand_passed) thousands_counter <= 0;
        else thousands_counter <= thousands_counter + 1;
end

// DC
always @(*) begin
    case (thousands_counter)
        4'h0 : DC_thousands = 7'b1000000;
        4'h1 : DC_thousands = 7'b1111001;
        4'h2 : DC_thousands = 7'b0100100;
        4'h3 : DC_thousands = 7'b0110000;
        4'h4 : DC_thousands = 7'b0011001;
        4'h5 : DC_thousands = 7'b0010010;
        4'h6 : DC_thousands = 7'b0000010;
        4'h7 : DC_thousands = 7'b1111000;
        4'h8 : DC_thousands = 7'b0000000;
        4'h9 : DC_thousands = 7'b0010000;

        default : DC_thousands = 7'd0111111;
    endcase
end 

// DC
always @(*) begin
    case (hundreds_counter)
        4'h0 : DC_hundreds = 7'b1000000;
        4'h1 : DC_hundreds = 7'b1111001;
        4'h2 : DC_hundreds = 7'b0100100;
        4'h3 : DC_hundreds = 7'b0110000;
        4'h4 : DC_hundreds = 7'b0011001;
        4'h5 : DC_hundreds = 7'b0010010;
        4'h6 : DC_hundreds = 7'b0000010;
        4'h7 : DC_hundreds = 7'b1111000;
        4'h8 : DC_hundreds = 7'b0000000;
        4'h9 : DC_hundreds = 7'b0010000;

        default : DC_hundreds = 7'd0111111;
    endcase
end 

// DC
always @(*) begin
    case (tens_counter)
        4'h0 : DC_tens = 7'b1000000;
        4'h1 : DC_tens = 7'b1111001;
        4'h2 : DC_tens = 7'b0100100;
        4'h3 : DC_tens = 7'b0110000;
        4'h4 : DC_tens = 7'b0011001;
        4'h5 : DC_tens = 7'b0010010;
        4'h6 : DC_tens = 7'b0000010;
        4'h7 : DC_tens = 7'b1111000;
        4'h8 : DC_tens = 7'b0000000;
        4'h9 : DC_tens = 7'b0010000;

        default : DC_tens = 7'd0111111;
    endcase
end 

// DC
always @(*) begin
    case (seconds_counter)
        4'h0 : DC_seconds = 7'b1000000;
        4'h1 : DC_seconds = 7'b1111001;
        4'h2 : DC_seconds = 7'b0100100;
        4'h3 : DC_seconds = 7'b0110000;
        4'h4 : DC_seconds = 7'b0011001;
        4'h5 : DC_seconds = 7'b0010010;
        4'h6 : DC_seconds = 7'b0000010;
        4'h7 : DC_seconds = 7'b1111000;
        4'h8 : DC_seconds = 7'b0000000;
        4'h9 : DC_seconds = 7'b0010000;

        default : DC_seconds = 7'd0111111;
    endcase
end 

// DC
always @(*) begin
    case (tenth_counter)
        4'h0 : DC_tenth = 7'b1000000;
        4'h1 : DC_tenth = 7'b1111001;
        4'h2 : DC_tenth = 7'b0100100;
        4'h3 : DC_tenth = 7'b0110000;
        4'h4 : DC_tenth = 7'b0011001;
        4'h5 : DC_tenth = 7'b0010010;
        4'h6 : DC_tenth = 7'b0000010;
        4'h7 : DC_tenth = 7'b1111000;
        4'h8 : DC_tenth = 7'b0000000;
        4'h9 : DC_tenth = 7'b0010000;

        default : DC_tenth = 7'd0111111;
    endcase
end 

// DC
always @(*) begin
    case (hundredth_counter)
        4'h0 : DC_hundredth = 7'b1000000;
        4'h1 : DC_hundredth = 7'b1111001;
        4'h2 : DC_hundredth = 7'b0100100;
        4'h3 : DC_hundredth = 7'b0110000;
        4'h4 : DC_hundredth = 7'b0011001;
        4'h5 : DC_hundredth = 7'b0010010;
        4'h6 : DC_hundredth = 7'b0000010;
        4'h7 : DC_hundredth = 7'b1111000;
        4'h8 : DC_hundredth = 7'b0000000;
        4'h9 : DC_hundredth = 7'b0010000;

        default : DC_hundredth = 7'd0111111;
    endcase
end 

assign HEX3 = DC_tens      * ~SW[0] + DC_thousands * SW[0];
assign HEX2 = DC_seconds   * ~SW[0] + DC_hundreds  * SW[0];
assign HEX1 = DC_tenth     * ~SW[0] + DC_tens      * SW[0];
assign HEX0 = DC_hundredth * ~SW[0] + DC_seconds   * SW[0];

endmodule

