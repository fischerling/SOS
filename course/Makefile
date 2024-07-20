# The full path to the Makefile
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
# The path to the directory of the Makefile
MAKEFILE_DIR := $(dir $(MAKEFILE_PATH))

SRC_DIRS := $(shell find "(" -not -path "./pandoc/*" -a "(" -name "*.md" -o -name "*.tex" ")" -printf "%h\n" ")" | uniq)

VERBOSE ?= @

.DEFAULT_GOAL := all
all: $(SRC_DIRS)

define generateRules
$(1):
	$(VERBOSE)echo "## Building $$@ ##"
	$(VERBOSE)if [ -d $$(@)/Makefile ]; then\
		$(MAKE) -C $$(@);\
	else\
		$(MAKE) -C $$(@) -f $(MAKEFILE_DIR)/toplevel-build.mk;\
	fi
endef

$(foreach dir, $(SRC_DIRS), $(eval $(call generateRules, $(dir))))

.PHONY: $(SRC_DIRS)
