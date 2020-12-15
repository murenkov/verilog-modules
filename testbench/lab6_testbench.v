module lab6_testbench ();

    reg clock;
    reg reset;

    reg ps2_clock;
    reg ps2_data;

    wire valid_data;
    wire [7:0] data;
    wire [6:0] HEX0, HEX1;

    wire [3:0] keys;
    assign keys = {3'b000, reset};

    lab6 UUT( 
        .KEY        (keys),
        .CLOCK_50   (clock),

        .ps2_clock  (ps2_clock), 
        .ps2_data   (ps2_data), 
          
        .valid_data (valid_data), 
        .data       (data),
        .HEX0       (HEX0),
        .HEX1       (HEX1)
    ); 

    initial begin
        $dumpfile("./lab6.vcd");
        $dumpvars(0, lab6_testbench);
    end

    initial begin
        clock = 0;
        reset = 0;

        ps2_clock = 1;
        ps2_data = 1;

        #20
        reset = 1;
        #20
        reset = 0;


        #5000
        ps2_send(8'h15);
        ps2_send(8'h35);
        ps2_send(8'hAB);
        ps2_send(8'hDF);
        ps2_send(8'h1D);

        #100
        $finish;
    end


    always
        #20 clock = ~clock;

    localparam PS2_HALFPERIOD = 1000;
    reg [7:0] ps2_shiftreg;

    integer i;

    task ps2_send;
        input [7:0] data;

        begin
            ps2_shiftreg = data;

            // Start bit
            ps2_clock = 0;
            ps2_data  = 0;
            #PS2_HALFPERIOD;
            ps2_clock = 1;
            #PS2_HALFPERIOD;

            // Data
            for (i = 0; i < 8; i = i + 1) begin
                ps2_clock = 0;
                ps2_data  = ps2_shiftreg[0];
                ps2_shiftreg = ps2_shiftreg >> 1;
                #PS2_HALFPERIOD;
                ps2_clock    = 1;
                #PS2_HALFPERIOD;
            end

            // Parity
            ps2_clock = 0;
            ps2_data  = ~(^data);
            #PS2_HALFPERIOD;
            ps2_clock = 1;
            #PS2_HALFPERIOD;

            // Stop bit
            ps2_clock = 0;
            ps2_data  = 1;
            #PS2_HALFPERIOD;
            ps2_clock = 1;
            #PS2_HALFPERIOD;

            // One period delay
            #(PS2_HALFPERIOD * 2);
        end
    endtask

endmodule

