
include $(LWC_ROOT)/lwc_common.mk
include $(LWC_ROOT)/lwc_ghdl.mk

VHDL_LINT_CMD := $(GHDL) -s --mb-comments $(GHDL_OPT) $(GHDL_WARNS)
VERILOG_LINT_CMD := verilator -Wall --lint-only

lint: lint-verilog lint-vhdl lint-yosys


lint-verilog: $(VERILOG_FILES)
ifneq ($(strip $(VERILOG_FILES)),)
	$(VERILOG_LINT_CMD) $(VERILOG_FILES)
endif

lint-vhdl: $(VHDL_FILES)
ifneq ($(strip $(VHDL_FILES)),)
	$(VHDL_LINT_CMD) $(VHDL_FILES)
endif

lint-vhdl-synth: $(WORK_LIB)-obj$(VHDL_STD).cf
ifneq ($(strip $(VHDL_FILES)),)
	$(GHDL) --synth $(GHDL_OPT) $(GHDL_WARNS) $(TOP) > /dev/null
endif

lint-yosys: $(WORK_LIB)-obj$(VHDL_STD).cf $(VERILOG_FILES)
	$(YOSYS_BIN) $(YOSYS_GHDL_MODULE) -p "$(YOSYS_READ_VHDL_CMD) $(YOSYS_READ_VERILOG_CMD) check -assert"