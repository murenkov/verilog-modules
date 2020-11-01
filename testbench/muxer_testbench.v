`timescale 1us/1ns

module muxer_testbench();

reg [9:0] SW;

wire [7:0] HEX0;
wire [3:0] mux_out;

localparam period = 2;

muxer UUT(
    .SW      (SW),
    .HEX0    (HEX0),
    .mux_out (mux_out)
);

initial begin
    $dumpfile("./muxer.vcd");
    $dumpvars;

    // Mode 1
    SW[9:8] = 2'b00;

    SW[3:0] = 4'b1100;
    #period;

    SW[3:0] = 4'b1111;
    #period;

    SW[3:0] = 4'b0000;
    #period;

    SW[3:0] = 4'b1010;
    #period;

    SW[3:0] = 4'b1110;
    #period;

    // Mode 2
    SW[9:8] = 2'b01;

    SW[7:4] = 4'b0000;
    #period;

    SW[7:4] = 4'b1111;
    #period;

    SW[7:4] = 4'b1010;
    #period;

    SW[7:4] = 4'b1110;
    #period;

    SW[7:4] = 4'b0101;
    #period;

    // Mode 3
    SW[9:8] = 2'b10;

    SW[3:0] = 4'b1001;
    #period;

    SW[3:0] = 4'b0000;
    #period;

    SW[3:0] = 4'b1111;
    #period;

    SW[3:0] = 4'b1010;
    #period;

    SW[3:0] = 4'b0111;
    #period;
    
//    $finish;
end

// initial begin
//     $monitor("time = %3d\t", $stime);
// end

endmodule

