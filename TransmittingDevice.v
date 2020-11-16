/*
* Transmitting device
* Accumulate data in FIFO, then send.
*/

module TransmittingDevice(
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,

    output [9:0] LEDR,
    output [6:0] HEX0
);
    localparam WORD_SIZE = 4;

    localparam IDLE     = 2'b00;
    localparam LOAD     = 2'b01;
    localparam TRANSMIT = 2'b10;
    
    reg [1:0] state;
    wire [WORD_SIZE-1:0] data_to_transmit;
    wire queue_is_empty, queue_is_full;
    wire queue_write_enable, queue_read_enable;
    wire transmitter_is_busy;
    wire start_transaction;

    // Reset button syncroniser
    reg [2:0] reset_button_sync;
    always @(posedge CLOCK_50) begin
        reset_button_sync[0] <= KEY[0];
        reset_button_sync[1] <= reset_button_sync[0];
        reset_button_sync[2] <= reset_button_sync[1];
    end
    wire reset;
    assign reset = ~reset_button_sync[2] & reset_button_sync[1];

    // Touch button syncroniser
    reg [2:0] touch_button_sync;
    always @(posedge CLOCK_50) begin
        touch_button_sync[0] <= KEY[1];
        touch_button_sync[1] <= touch_button_sync[0];
        touch_button_sync[2] <= touch_button_sync[1];
    end
    wire touch;
    assign touch = ~touch_button_sync[2] & touch_button_sync[1];

    // Touch counter
    reg [WORD_SIZE-1:0] touch_counter;
    always @(posedge CLOCK_50 or posedge reset)
        if (reset)
            touch_counter <= 0;
        else if (touch)
            touch_counter <= touch_counter + 1;

    // Pulse counter 
    // TODO: set localparam PULSES_IN_SEC = 50 * 1000 * 1000 - 1;
    localparam PULSES_IN_SEC = 10 - 1;
    reg [26:0] pulse_counter = 0;
    wire second_passed = (pulse_counter == PULSES_IN_SEC);
    always @(posedge CLOCK_50 or posedge reset)
        if (reset)
            pulse_counter <= 0;
        else 
            pulse_counter <= (second_passed) ? 0 : pulse_counter + 1;

    // Seconds counter 
    reg [3:0] seconds_counter = 0;
    always @(posedge CLOCK_50 or posedge reset)
        if (reset)
            seconds_counter <= 0;
        else if (second_passed)
            seconds_counter <= (seconds_counter == 9) ? 0 : seconds_counter + 1;

    // State handler
    always @(posedge CLOCK_50 or posedge reset)
        if (reset)
            state <= IDLE;
        else 
            case (state)
                IDLE:
                    if (!queue_is_empty && !transmitter_is_busy) 
                        state <= LOAD;

                LOAD:
                    state <= TRANSMIT;

                TRANSMIT:
                    state <= IDLE;
            endcase

    assign LEDR = (queue_is_full)  ? 10'b1111111111 : 
                  (queue_is_empty) ? 10'b0000000000 : 10'b0000011111;
    assign queue_write_enable = touch;
    assign queue_read_enable = (state == LOAD);
    assign start_transaction = (state == TRANSMIT);

    FIFO Queue(
        .clock        (CLOCK_50),
        .reset        (reset),
        .write_enable (queue_write_enable),
        .read_enable  (queue_read_enable),
        .data_in      (touch_counter),
        .full         (queue_is_full),
        .empty        (queue_is_empty),
        .data_out     (data_to_transmit)
    );

    Transmitter Transmitter(
        .data_in (data_to_transmit),
        .start   (start_transaction),
        .busy    (transmitter_is_busy),
        .tx      (HEX0)
    );

endmodule

