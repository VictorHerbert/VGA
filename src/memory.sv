module Memory #(parameter SIZE, parameter WIDTH)(
    input clk,
    input write_enable,
    
    input       [$clog2(SIZE)-1:0] read_addr,
    input       [$clog2(SIZE)-1:0] write_addr,

    input       [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] data_out
);

	reg [WIDTH-1:0] data [SIZE-1:0];
    reg [$clog2(SIZE)-1:0] read_addr_reg;

    assign  data_out = data[read_addr];

    initial begin
        foreach(data[i]) data[i] = 0;
    end

    always @ (posedge clk) begin
        if (write_enable) begin
            data[write_addr] <= data_in;
        end

        read_addr_reg <= read_addr;
    end
    

endmodule