module reg_8bit(
    input      [7:0] data,
    input            enable,
    input            reset,
    input            clock,

    output reg [7:0] q
);

    always @(posedge clock or posedge reset) begin
        if (reset) q <= 0;
        else if (enable) q <= data;
    end

endmodule

