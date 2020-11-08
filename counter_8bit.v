module counter_8bit(
    input            enable,
    input            clock,
    input            reset,

    output reg [3:0] counter
);

    localparam LENGTH = 3;

    always @(posedge clock or posedge reset) begin
        if (reset)
            counter <= 0;
        else if (enable)
            // counter <= (counter == 2 ** LENGTH) ? 0 : counter + 1;
            counter <= counter + 1;
    end

endmodule

