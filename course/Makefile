# The full path to the Makefile
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
# The path to the directory of the Makefile
MAKEFILE_DIR := $(dir $(MAKEFILE_PATH))

include $(MAKEFILE_DIR)/common.mk

SRC_DIRS := $(shell find "(" -not -path "./pandoc/*" -a "(" -name "*.md" -o -name "*.tex" ")" -printf "%h\n" ")" | uniq)

.DEFAULT_GOAL := all
all: $(SRC_DIRS)

define generateRules
$(1):
	@echo "## Building $$@ ##"
	$(VERBOSE)make -C $$(@) -f $(MAKEFILE_DIR)/common.mk
endef

$(foreach dir, $(SRC_DIRS), $(eval $(call generateRules, $(dir))))

.PHONY: $(SRC_DIRS)
