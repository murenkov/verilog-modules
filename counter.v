module counter_8bit(
    input            enable,
    input            clock,
    input            reset,

    output reg [7:0] counter
);

    always @(posedge clock or posedge reset) begin
        if (reset) counter <= 0;
        else if (enable) counter <= counter + 1;
    end

endmodule

