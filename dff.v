module dff(
    input data,
    input enable,

    output Q,
);

always @(enable, data) begin
    if (enable) Q <= data;
end

endmodule

