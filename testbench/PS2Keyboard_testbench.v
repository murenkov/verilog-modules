/*
* Testbench for PS2Keyboard.v
*/

`timescale 1us/1ns

module PS2Keyboard_testbench();

    reg clock, reset;
    reg ps2_clock, ps2_data;

    wire data_is_valid;
    wire [6:0] HEX0, HEX1;

    localparam CLOCK_PERIOD = 1;
    // localparam PERIOD = 1;
    // localparam LONG_PERIOD = 20;
    // localparam MEDIUM_PERIOD = 4;
    localparam PS2_HALFPERIOD = 50;

    reg [7:0] ps2_shiftreg;

    PS2Keyboard UUT(
        .clock         (clock),
        .reset         (reset),
        .ps2_clock     (ps2_clock),
        .ps2_data      (ps2_data),
        .data_is_valid (data_is_valid),
        .HEX0          (HEX0),
        .HEX1          (HEX1)
    );

    always begin
        #CLOCK_PERIOD;
        clock = ~clock;
    end

    initial begin
        $dumpfile("./PS2Keyboard.vcd");
        $dumpvars(0, PS2Keyboard_testbench);

        clock = 0;
        reset = 0;

        ps2_clock = 1;
        ps2_data = 1;

        #100;
        ps2_send(8'h3A);
        ps2_send(8'h31);

        ps2_send(8'h15);
        ps2_send(8'h2D);

        ps2_send(8'h12);
        #100;

        $finish;
    end

    integer i;
    task ps2_send;
        input [7:0] data;

        begin
            ps2_shiftreg = data;

            // Start bit
            ps2_clock = ~ps2_clock;
            ps2_data = 0;
            #PS2_HALFPERIOD;
            ps2_clock = 1;
            #PS2_HALFPERIOD;

            // Data
            for (i = 0; i < 8; i = i + 1) begin
                ps2_clock = 0;
                ps2_data = ps2_shiftreg[0];
                #PS2_HALFPERIOD;
                ps2_clock = 1;
                ps2_data = ps2_shiftreg >> 1;
                #PS2_HALFPERIOD;
            end

            // Parity check
            ps2_clock = 0;
            ps2_data = ~^data;
            #PS2_HALFPERIOD;
            ps2_clock = 1;
            #PS2_HALFPERIOD;

            // Stop bit
            ps2_clock = 0;
            ps2_data = 1;
            #PS2_HALFPERIOD;
            ps2_clock = 1;
            #PS2_HALFPERIOD;
            
            // Delay
            #(PS2_HALFPERIOD * 2);
        end
    endtask
/*
    initial begin
        $dumpfile("./PS2Keyboard.vcd");
        $dumpvars(0, PS2Keyboard_testbench);

        clock = 0;
        ps2_clock = 0;

        reset = 1;
        ps2_data = 1;
        #PERIOD;
        reset = 0;
        #LONG_PERIOD;

        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 0;
        #MEDIUM_PERIOD;
        #MEDIUM_PERIOD;
        ps2_data = 1;
        #LONG_PERIOD;


        $finish;
    end
    */

endmodule

