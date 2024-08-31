//import vga_config::*;

module VGA (
    clk, reset, write_enable, write_addr, pixel_in, pixel_out, h_sync, v_sync
);

    parameter int RED_WIDTH;
    parameter int GREEN_WIDTH;
    parameter int BLUE_WIDTH;

    parameter int H_VISIBLE_AREA;
    parameter int H_FRONT_PORCH;
    parameter int H_SYNC_PULSE;
    parameter int H_BACK_PORCH;

    parameter int V_VISIBLE_AREA;
    parameter int V_FRONT_PORCH;
    parameter int V_SYNC_PULSE;
    parameter int V_BACK_PORCH;
        
    localparam MEM_SIZE = H_VISIBLE_AREA * V_VISIBLE_AREA;
    localparam PIXEL_WIDTH = RED_WIDTH + GREEN_WIDTH + BLUE_WIDTH;
    localparam H_LINE = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
    localparam V_LINE = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    input clk, reset;

    input write_enable;
    input [$clog2(MEM_SIZE)-1:0] write_addr;
    input [PIXEL_WIDTH-1:0] pixel_in;

    output [PIXEL_WIDTH-1:0] pixel_out;
    output h_sync, v_sync;

    wire [$clog2(H_LINE-1)-1:0] horizontal_coord;
    wire [$clog2(V_LINE-1)-1:0] vertical_coord;
    wire [$clog2(MEM_SIZE)-1:0] idx;
    wire valid;

    VGAController #(
        .H_VISIBLE_AREA(H_VISIBLE_AREA),
        .H_FRONT_PORCH(H_FRONT_PORCH),
        .H_SYNC_PULSE(H_SYNC_PULSE),
        .H_BACK_PORCH(H_BACK_PORCH),

        .V_VISIBLE_AREA(V_VISIBLE_AREA),
        .V_FRONT_PORCH(V_FRONT_PORCH),
        .V_SYNC_PULSE(V_SYNC_PULSE),
        .V_BACK_PORCH(V_BACK_PORCH)
    ) vga_controller(
        .clk, .reset,
        .horizontal_coord, .vertical_coord, .idx,
        .h_sync, .v_sync, .valid
    );

    Memory #(
        .SIZE(MEM_SIZE),
        .WIDTH(PIXEL_WIDTH)
    ) framebuffer(
        .clk, .write_enable,

        .read_addr(idx),
        .write_addr(write_addr),

        .data_in(pixel_in),
        .data_out(pixel_out)
    );

    /*assign pixel_out = {
        horizontal_coord[$clog2(H_LINE-1)-1:$clog2(H_LINE-1)-1-4],
        vertical_coord[$clog2(V_LINE-1)-1:$clog2(V_LINE-1)-1-4],
        4'b0000};*/

endmodule