MODELSIM_BUILD_DIR := eda/modelsim/build
SCRIPT_DIR := scripts
BUILD_DIR := build


all: $(BUILD_DIR)/output.png

$(BUILD_DIR)/output.png: $(MODELSIM_BUILD_DIR)/output.txt
	python $(SCRIPT_DIR)/log_to_image.py $(MODELSIM_BUILD_DIR)/output.txt $(BUILD_DIR)/output.png
	
$(MODELSIM_BUILD_DIR)/output.txt: test/testbench.sv src/*.sv
	cd $(MODELSIM_BUILD_DIR) && vsim -c -do ../run.do

clean:
	wsl rm -f image.png output.txt


