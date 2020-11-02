module latch(
    input set,
    input reset,

    output Q,
    output nQ
);

    assign Q = ~(set & nQ);
    assign nQ = ~(reset & Q);

endmodule

