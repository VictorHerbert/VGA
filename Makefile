MODELSIM_BUILD_DIR := eda/modelsim/build
SCRIPT_DIR := scripts
BUILD_DIR := build

all: check

image: $(MODELSIM_BUILD_DIR)/input.txt

$(BUILD_DIR):
	wsl mkdir -p $(BUILD_DIR)

$(MODELSIM_BUILD_DIR):
	wsl mkdir -p $(MODELSIM_BUILD_DIR)

$(MODELSIM_BUILD_DIR)/input.txt: $(BUILD_DIR) img/lena.png $(SCRIPT_DIR)/image_formatter.py
	python $(SCRIPT_DIR)/image_formatter.py img/lena.png $(MODELSIM_BUILD_DIR)/input.txt

$(MODELSIM_BUILD_DIR)/output.txt: $(MODELSIM_BUILD_DIR) $(MODELSIM_BUILD_DIR)/input.txt test/testbench.sv src/*.sv
	cd $(MODELSIM_BUILD_DIR) && vsim -c -do ../run.do

$(BUILD_DIR)/output.png: $(BUILD_DIR) $(MODELSIM_BUILD_DIR)/output.txt  $(SCRIPT_DIR)/log_to_image.py
	python $(SCRIPT_DIR)/log_to_image.py $(MODELSIM_BUILD_DIR)/output.txt $(BUILD_DIR)/output.png

clean:
	wsl rm -r $(BUILD_DIR) $(MODELSIM_BUILD_DIR)

.PHONY: all clean check

