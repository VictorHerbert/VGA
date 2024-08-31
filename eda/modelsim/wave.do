onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/write_enable
add wave -noupdate /testbench/write_addr
add wave -noupdate /testbench/pixel_in
add wave -noupdate /testbench/pixel_out
add wave -noupdate /testbench/red
add wave -noupdate /testbench/green
add wave -noupdate /testbench/blue
add wave -noupdate -divider Controller
add wave -noupdate /testbench/vga/vga_controller/horizontal_coord
add wave -noupdate /testbench/vga/vga_controller/vertical_coord
add wave -noupdate /testbench/vga/vga_controller/h_sync
add wave -noupdate /testbench/vga/vga_controller/v_sync
add wave -noupdate /testbench/vga/vga_controller/valid
add wave -noupdate -divider Framebuffer
add wave -noupdate /testbench/vga/framebuffer/write_enable
add wave -noupdate /testbench/vga/framebuffer/write_addr
add wave -noupdate /testbench/vga/framebuffer/data_in
add wave -noupdate /testbench/vga/framebuffer/read_addr
add wave -noupdate /testbench/vga/framebuffer/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6365 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {19666 ps} {20018 ps}
