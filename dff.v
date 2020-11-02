module dff(
    input data,
    input enable,
    input set,
    input reset,
    input clock,

    output reg Q
);

    always @(posedge clock or posedge reset) begin
        if (reset) Q <= 0;
        else if (enable) Q <= data;
    end

endmodule

