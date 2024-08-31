//import vga_config::*;

module testbench;

    localparam int CLK_PERIOD = 10;
    localparam int CLK_HALF_PERIOD = CLK_PERIOD/2;
    
    localparam int H_VISIBLE_AREA = 50;
    localparam int V_VISIBLE_AREA = 50;
    localparam int MEM_SIZE = H_VISIBLE_AREA * V_VISIBLE_AREA;

    localparam int RED_WIDTH = 4;
    localparam int GREEN_WIDTH = 4;
    localparam int BLUE_WIDTH = 4;
    localparam int PIXEL_WIDTH = RED_WIDTH + GREEN_WIDTH + BLUE_WIDTH;

    logic clk = 0, reset = 0;

    logic write_enable;
    logic [32-1:0] write_addr;
    logic [RED_WIDTH-1:0] red;
    logic [GREEN_WIDTH-1:0] green;
    logic [BLUE_WIDTH-1:0] blue;
    logic [PIXEL_WIDTH-1:0] pixel_in;    

    logic [12-1:0] pixel_out;
    logic h_sync, v_sync;

    assign {red, green, blue} = pixel_out;

    VGA #(
        .RED_WIDTH(RED_WIDTH),
        .GREEN_WIDTH(GREEN_WIDTH),
        .BLUE_WIDTH(BLUE_WIDTH),

        .H_VISIBLE_AREA(H_VISIBLE_AREA),
        .H_FRONT_PORCH(2),
        .H_SYNC_PULSE(4),
        .H_BACK_PORCH(5),

        .V_VISIBLE_AREA(V_VISIBLE_AREA),
        .V_FRONT_PORCH(2),
        .V_SYNC_PULSE(4),
        .V_BACK_PORCH(5)
    ) vga (
        .clk, .reset,

        .write_enable,
        .write_addr,

        .pixel_in,

        .pixel_out,
        .h_sync, .v_sync
    );

    initial repeat(40000) #CLK_HALF_PERIOD clk = ~clk;

    task wait_ticks(integer n); repeat(n) @(posedge clk); endtask

    task write_data(integer addr, [PIXEL_WIDTH-1:0] value); begin
        write_enable = 1;
        pixel_in = value;
        write_addr = addr;
        wait_ticks(1);
        write_enable = 0;
        write_addr = 'x;
        pixel_in = 'x;
    end
    endtask

    initial begin
        integer file;

        reset <= 1;
        wait_ticks(1);

        file = $fopen("output.txt", "w");
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end

        for(int i = 0; i < H_VISIBLE_AREA; i++) begin 
            for(int j = 0; j < V_VISIBLE_AREA; j++) begin
                write_data(i * V_VISIBLE_AREA + j, {i[5:2], j[5:2], i[0]&j[0], 3'b00});
            end
        end

        wait_ticks(1);
        reset <= 0;

        while (1) begin
            @(posedge clk) #1;
                if($isunknown(pixel_out))
                    $fdisplay(file, "%0d ns: %b %b 0 0 0", $time, h_sync, v_sync);
                else
                    $fdisplay(file, "%0d ns: %b %b %b %b %b", $time, h_sync, v_sync, red, green, blue);
                //$fdisplay(file, "idx: %4d h %4d v %4d", vga.idx, vga.horizontal_coord, vga.vertical_coord);
        end
                

    end
    

endmodule