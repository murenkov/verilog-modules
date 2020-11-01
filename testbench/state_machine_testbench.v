/*
* Testbench for state_machine.v
*/

`timescale 1us/1ns

module state_machine_testbench();

    reg CLOCK_50;
    reg [3:0] KEY;

    wire [6:0] HEX0;

    localparam clock_period = 0.5;
    localparam period = 1;

    state_machine UUT(
        .CLOCK_50 (CLOCK_50),
        .KEY      (KEY),
        .HEX0     (HEX0)
    );

    always begin
        #clock_period
        CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        $dumpfile("./state_machine.vcd");
        $dumpvars(0, state_machine_testbench);

        CLOCK_50 = 0;
        KEY = 0;
        #period;

        KEY[3] = 1;
        #period;
        KEY[3] = 0;
        #period;
        #period;
        
        KEY[0] = 1;
        #period;
        KEY[0] = 0;
        #period;
        #period;
        
        KEY[2] = 1;
        #period;
        KEY[2] = 0;
        #period;
        #period;
        
        KEY[0] = 1;
        #period;
        KEY[0] = 0;
        #period;
        #period;
        
        KEY[1] = 1;
        #period;
        KEY[1] = 0;
        #period;
        #period;
        
        KEY[2] = 1;
        #period;
        KEY[2] = 0;
        #period;
        #period;
        
        KEY[1] = 1;
        #period;
        KEY[1] = 0;
        #period;
        #period;
        
        KEY[0] = 1;
        #period;
        KEY[0] = 0;
        #period;
        #period;
        
        KEY[1] = 1;
        #period;
        KEY[1] = 0;
        #period;
        #period;
        
        KEY[0] = 1;
        #period;
        KEY[0] = 0;
        #period;
        #period;
        
        KEY[1] = 1;
        #period;
        KEY[1] = 0;
        #period;
        #period;
        
        KEY[2] = 1;
        #period;
        KEY[2] = 0;
        #period;
        #period;
        
        KEY[3] = 1;
        #period;
        KEY[3] = 0;
        #period;
        #period;

        $finish;
    end

endmodule

