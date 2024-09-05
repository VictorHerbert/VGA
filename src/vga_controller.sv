//import vga_config::*;

module VGAController (
    clk, reset, horizontal_coord, vertical_coord, idx, h_sync, v_sync, valid
);

    parameter int H_VISIBLE_AREA;
    parameter int H_FRONT_PORCH;
    parameter int H_SYNC_PULSE;
    parameter int H_BACK_PORCH;

    parameter int V_VISIBLE_AREA;
    parameter int V_FRONT_PORCH;
    parameter int V_SYNC_PULSE;
    parameter int V_BACK_PORCH;

    localparam MEM_SIZE = H_VISIBLE_AREA * V_VISIBLE_AREA;

    localparam H_LINE = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
    localparam V_LINE = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    localparam H_SYNC_ON_TRIGGER = H_VISIBLE_AREA + H_FRONT_PORCH;
    localparam H_SYNC_OFF_TRIGGER  = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE ;

    localparam V_SYNC_ON_TRIGGER = V_VISIBLE_AREA + V_FRONT_PORCH;
    localparam V_SYNC_OFF_TRIGGER  = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE;


    input clk, reset;

    output reg [$clog2(H_LINE)-1:0] horizontal_coord;
    output reg [$clog2(V_LINE)-1:0] vertical_coord;

    output reg [$clog2(MEM_SIZE)-1:0] idx;

    output reg h_sync, v_sync, valid;

    wire horizontal_count_enable, vertical_count_enable;
    wire horizontal_roll_out, vertical_roll_out;

    assign horizontal_count_enable = 1;
    assign vertical_count_enable = horizontal_count_enable & (horizontal_coord == H_LINE-1);

    assign horizontal_roll_out = (horizontal_coord == H_LINE-1);
    assign vertical_roll_out = (vertical_coord == V_LINE-1);

    assign valid = (horizontal_coord < H_VISIBLE_AREA) && (vertical_coord < V_VISIBLE_AREA);

    always_ff @(posedge clk) begin
        if(reset) begin
            horizontal_coord = 0; vertical_coord = 0;
            h_sync = 1; v_sync = 1;
            idx = 0;
        end
        else begin
            if(horizontal_count_enable)
                horizontal_coord = horizontal_roll_out ? 0 : horizontal_coord + 1;

            if(vertical_count_enable) begin
                vertical_coord = vertical_roll_out ? 0 : vertical_coord + 1;
                idx = vertical_roll_out ? 0 : idx;
            end
            else
                idx += valid;

            if(horizontal_coord == H_SYNC_ON_TRIGGER)
                h_sync = 0;
            else if(horizontal_coord == H_SYNC_OFF_TRIGGER)
                h_sync = 1;

            if(vertical_coord == V_SYNC_ON_TRIGGER)
                v_sync = 0;
            else if(vertical_coord == V_SYNC_OFF_TRIGGER)
                v_sync = 1;
        end

        
    end


endmodule