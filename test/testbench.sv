//import vga_config::*;

module testbench;

    localparam int CLK_PERIOD = 10;
    localparam int CLK_HALF_PERIOD = CLK_PERIOD/2;
    
    localparam int H_VISIBLE_AREA = 320;
    localparam int H_FRONT_PORCH = 5;
    localparam int H_SYNC_PULSE = 5;
    localparam int H_BACK_PORCH = 5;

    localparam int V_VISIBLE_AREA = 240;
    localparam int V_FRONT_PORCH = 5;
    localparam int V_SYNC_PULSE = 5;
    localparam int V_BACK_PORCH = 5;

    localparam int MEM_SIZE = H_VISIBLE_AREA * V_VISIBLE_AREA;
    
    localparam H_LINE = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
    localparam V_LINE = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    localparam int RED_WIDTH = 4;
    localparam int GREEN_WIDTH = 4;
    localparam int BLUE_WIDTH = 4;
    localparam int PIXEL_WIDTH = RED_WIDTH + GREEN_WIDTH + BLUE_WIDTH;

    logic clk = 0, reset = 0;

    logic write_enable;
    logic [32-1:0] write_addr;
    logic [RED_WIDTH-1:0] red_in, red_out;
    logic [GREEN_WIDTH-1:0] green_in, green_out;
    logic [BLUE_WIDTH-1:0] blue_in, blue_out;
    logic [PIXEL_WIDTH-1:0] pixel_in, data;

    logic [12-1:0] pixel_out;
    logic h_sync, v_sync;

    assign {red_out, green_out, blue_out} = pixel_out;

    VGA #(
        .RED_WIDTH(RED_WIDTH),
        .GREEN_WIDTH(GREEN_WIDTH),
        .BLUE_WIDTH(BLUE_WIDTH),

        .H_VISIBLE_AREA(H_VISIBLE_AREA),
        .H_FRONT_PORCH(H_FRONT_PORCH),
        .H_SYNC_PULSE(H_SYNC_PULSE),
        .H_BACK_PORCH(H_BACK_PORCH),

        .V_VISIBLE_AREA(V_VISIBLE_AREA),
        .V_FRONT_PORCH(V_FRONT_PORCH),
        .V_SYNC_PULSE(V_SYNC_PULSE),
        .V_BACK_PORCH(V_BACK_PORCH)
    ) vga (
        .clk, .reset,

        .write_enable,
        .write_addr,

        .pixel_in,

        .pixel_out,
        .h_sync, .v_sync
    );

    initial repeat(1000000) #CLK_HALF_PERIOD clk = ~clk;

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
        integer in_file, out_file;

        reset <= 1;
        wait_ticks(1);

        in_file = $fopen("input.txt", "r");
        
        if (out_file == 0) begin
            $display("Error: Could not open in_file.");
            $finish;
        end

        out_file = $fopen("output.txt", "w");
        
        if (out_file == 0) begin
            $display("Error: Could not open out_file.");
            $finish;
        end

        for(int i = 0; i < H_VISIBLE_AREA; i++) begin 
            for(int j = 0; j < V_VISIBLE_AREA; j++) begin
                $fscanf(in_file, "%d\n", data); 
                write_data(i * V_VISIBLE_AREA + j, data);

                /*if(i == 0 | j == 0 | i == H_VISIBLE_AREA-1 | j == V_VISIBLE_AREA-1)
                    write_data(j * H_VISIBLE_AREA + i, {12'hFFF});
                else
                    write_data(j * H_VISIBLE_AREA + i, {i[8:4], j[8:4], 4'h0});*/
            end
        end

        wait_ticks(1);
        reset <= 0;

        while (1) begin
            @(posedge clk) #1;
                if($isunknown(pixel_out))
                    $fdisplay(out_file, "%0d ns: %b %b 0 0 0", $time, h_sync, v_sync);
                else
                    $fdisplay(out_file, "%0d ns: %b %b %b %b %b", $time, h_sync, v_sync, red_out, green_out, blue_out);
                //$fdisplay(out_file, "idx: %4d h %4d v %4d", vga.idx, vga.horizontal_coord, vga.vertical_coord);
        end
                

    end
    

endmodule