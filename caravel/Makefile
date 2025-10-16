MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

RUN_TAG ?= $(shell ls librelane/runs/ | tail -n 1)

TOP = chip_top

PDK_ROOT ?= $(MAKEFILE_DIR)/../gf180mcu
PDK ?= gf180mcuD

.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
.PHONY: help

all: librelane ## Build the project (runs librelane)
.PHONY: all

librelane: ## Run librelane flow (synthesis, PnR, verification)
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk
.PHONY: librelane

librelane-openroad: ## Open the last run in OpenROAD
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInOpenROAD
.PHONY: librelane-openroad

librelane-klayout: ## Open the last run in KLayout
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInKLayout
.PHONY: librelane-klayout

sim: ## Run RTL simulation 
	cd sim && ./iverilog.sh
.PHONY: sim

sim-gl: ## Run gate-level simulation with cocotb
	cd sim && ./iverilog-gl.sh
.PHONY: sim-gl

copy-final: ## Copy final output files from the last run
	rm -rf final/
	cp -r librelane/runs/${RUN_TAG}/final/ final/
	gzip -f9 final/gds/caravel_core.gds
.PHONY: copy-final
