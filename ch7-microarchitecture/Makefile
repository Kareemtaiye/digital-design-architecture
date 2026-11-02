# # Compiler and flags
# CC = iverilog
# FLAGS = -g2012
# OUTPUT = cpu_sim

# # Source files grouped by directory
# SRC_DIR = 1_single_cycle
# TEST_DIR = tests

# # List all component files and test files with their paths
# SOURCES = \
#     $(SRC_DIR)/adder.sv \
#     $(SRC_DIR)/mux2.sv \
#     $(SRC_DIR)/mux3.sv \
#     $(SRC_DIR)/flopr.sv \
#     $(SRC_DIR)/flopenr.sv \
#     $(SRC_DIR)/extend.sv \
#     $(SRC_DIR)/alu.sv \
#     $(SRC_DIR)/regfile.sv \
#     $(SRC_DIR)/main_decoder.sv \
#     $(SRC_DIR)/alu_decoder.sv \
#     $(SRC_DIR)/controller.sv \
#     $(SRC_DIR)/datapath.sv \
#     $(SRC_DIR)/riscvsingle.sv \
#     $(TEST_DIR)/imem.sv \
#     $(TEST_DIR)/dmem.sv \
#     $(TEST_DIR)/top.sv \
#     $(TEST_DIR)/riscvtest.sv

# # Target 1: Compile the design
# compile:
# 	$(CC) $(FLAGS) -o $(OUTPUT) $(SOURCES)

# # Target 2: Run the simulation (executes vvp)
# run: compile
# 	./$(OUTPUT)

# # Clean up generated simulation files
# clean:
# 	rm -f $(OUTPUT) waveform.vcd

# Tools
IVERILOG = iverilog
VVP      = vvp
FLAGS    = -g2012 -Wall
    
BUILD  = ../build
SIM    = $(BUILD)/sim
WAVES  = $(BUILD)/waveforms
OUTPUT = $(SIM)/single_cycle.out
VCD    = $(WAVES)/single_cycle.vcd

# Source folders
SRC_DIR  = 1_single_cycle
TEST_DIR = tests

DESIGN = \
    $(SRC_DIR)/adder.sv \
    $(SRC_DIR)/mux2.sv \
    $(SRC_DIR)/mux3.sv \
    $(SRC_DIR)/flopr.sv \
    $(SRC_DIR)/flopenr.sv \
    $(SRC_DIR)/extend.sv \
    $(SRC_DIR)/alu.sv \
    $(SRC_DIR)/regfile.sv \
    $(SRC_DIR)/main_decoder.sv \
    $(SRC_DIR)/alu_decoder.sv \
    $(SRC_DIR)/controller.sv \
    $(SRC_DIR)/datapath.sv \
    $(SRC_DIR)/riscvsingle.sv

# Testbench files
TESTS = \
    $(TEST_DIR)/imem.sv \
    $(TEST_DIR)/dmem.sv \
    $(TEST_DIR)/top.sv \
    $(TEST_DIR)/riscvtest.sv

.PHONY: all compile run lint wave clean

all: run

# Compile (rebuilds only when a source file changes)
$(OUTPUT): $(DESIGN) $(TESTS)
	@mkdir -p $(SIM) $(WAVES)
	$(IVERILOG) $(FLAGS) -o $@ $(DESIGN) $(TESTS)

compile: $(OUTPUT)

# Run the simulation
run: $(OUTPUT)
	$(VVP) $(OUTPUT)

lint:
	verilator --lint-only -Wall --top-module riscvsingle $(DESIGN)

# Remove only this project's generated files
clean:
	rm -f $(OUTPUT) $(VCD)