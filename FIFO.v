/*
* First In First Out buffer
*/

module FIFO(
    input clock, reset,
    input write_enable, read_enable,
    input [WORD_SIZE-1:0] data_in,

    output reg full, empty,
    output reg [WORD_SIZE-1:0] data_out
);

    localparam ADDRESS_SIZE = 16;
    localparam WORD_SIZE = 4;

    reg [ADDRESS_SIZE-1:0] write_pointer, write_pointer_next;
    reg [ADDRESS_SIZE-1:0] read_pointer, read_pointer_next;
    reg [WORD_SIZE-1:0] memory [ADDRESS_SIZE-1:0];
    reg full_next, empty_next;

    // Read-write block
    integer i;
    always @(posedge clock or posedge reset)
        if (reset) 
            for (i = 0; i < ADDRESS_SIZE; i = i + 1)
                memory[i] <= 0;
        else begin
            if (~full && write_enable)
                memory[write_pointer] <= data_in;
            if (~empty && read_enable)
                data_out <= memory[read_pointer];
        end

    // FIFO controller
    always @(posedge clock or posedge reset)
        if (reset) begin
            write_pointer <= 0;
            read_pointer  <= 0;
            full  <= 0;
            empty <= 1;
        end
        else begin
            write_pointer <= write_pointer_next;
            read_pointer  <= read_pointer_next;
            full  <= full_next;
            empty <= empty_next;
        end

    // Next state logic for pointers
    always @(*) begin
        write_pointer_next = write_pointer;
        read_pointer_next  = read_pointer;
        full_next  = full;
        empty_next = empty;

        case ({write_enable, read_enable})
            2'b01:
                if (~empty) begin
                    read_pointer_next = (read_pointer + 1) % ADDRESS_SIZE;
                    full_next = 0;
                end

            2'b10:
                if (~full) begin
                    write_pointer_next = (write_pointer + 1) % ADDRESS_SIZE;
                    empty_next = 0;
                end

            2'b11:
                begin
                    read_pointer_next  = (read_pointer  + 1) % ADDRESS_SIZE;
                    write_pointer_next = (write_pointer + 1) % ADDRESS_SIZE;
                end
        endcase
    end

endmodule

