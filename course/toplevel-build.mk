# The full path to the Makefile
MAKEFILE_PATH ?= $(abspath $(lastword $(MAKEFILE_LIST)))
# The path to the directory of the Makefile
MAKEFILE_DIR ?= $(dir $(MAKEFILE_PATH))

include $(MAKEFILE_DIR)/common.mk

BUILDDIR := $(MAKEFILE_DIR)build
CURBUILDDIR := $(BUILDDIR)/$(subst $(MAKEFILE_DIR),,$(CURDIR))

.DEFAULT_GOAL := all
.PHONY: all
all: $(TEX_SRC:%.tex=$(CURBUILDDIR)/%.pdf) $(MD_SRC:%.md=$(CURBUILDDIR)/%.pdf)

$(CURBUILDDIR)/%.pdf: %.pdf
	$(VERBOSE)[ ! -d "$(CURBUILDDIR)" ] && mkdir -p "$(CURBUILDDIR)" || true
	$(VERBOSE)cp $< $@
