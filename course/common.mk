# The full path to the Makefile
MAKEFILE_PATH ?= $(abspath $(lastword $(MAKEFILE_LIST)))
# The path to the directory of the Makefile
MAKEFILE_DIR ?= $(dir $(MAKEFILE_PATH))

BUILDDIR := $(MAKEFILE_DIR)build

IMGS := $(wildcard img/*)
COMMON_IMAGES := $(MAKEFILE_DIR)/images

PANDOC_DIR := $(MAKEFILE_DIR)pandoc
PANDOC_FILTER_DIR := $(PANDOC_DIR)/filters
PANDOC_TEMPLATE_DIR := $(PANDOC_DIR)/templates

PANDOC_FILTER_OPTIONS := --lua-filter "$(PANDOC_FILTER_DIR)/center-img.lua"
PANDOC_FILTER_OPTIONS += --lua-filter "$(PANDOC_FILTER_DIR)/include-files.lua"
PANDOC_FILTER_OPTIONS += --lua-filter "$(PANDOC_FILTER_DIR)/meta-vars.lua"
PANDOC_FILTER_OPTIONS += --filter pandoc-plot
COMMON_PANDOC_OPTIONS := --resource-path="$(COMMON_IMAGES):." $(PANDOC_FILTER_OPTIONS)
PANDOC := pandoc $(COMMON_PANDOC_OPTIONS)

SLIDES_OPTIONS := --slide-level 2 -t beamer
SLIDES_OPTIONS += --pdf-engine-opt=--shell-escape
SLIDES_OPTIONS += --metadata-file=$(PANDOC_DIR)/defaults/slides-metadata.yml
SLIDES_OPTIONS += --template=$(PANDOC_TEMPLATE_DIR)/beamer.tex

VERBOSE ?= @
ifeq ($(VERBOSE), @)
	RUBBER_OPTS += --quiet
	SILENCE := > /dev/null
endif

slides.pdf: slides.md $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)[ ! -d "$(BUILDDIR)/$(subst $(MAKEFILE_DIR),,$(CURDIR))" ] && \
	    mkdir -p $(BUILDDIR)/$(subst $(MAKEFILE_DIR),,$(CURDIR)) || true
	$(VERBOSE)$(PANDOC) $(SLIDES_OPTIONS) $< -o $(BUILDDIR)/$(subst $(MAKEFILE_DIR),,$(CURDIR))/$@

slides_handout.pdf: slides_handout.md $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)$(PANDOC) $(SLIDES_OPTIONS) $< -M handout -o $@

slides%.pdf: slides%.md $(wildcard slides.md) $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	@[ ! -d $(BUILDDIR)$(subst $(MAKEFILE_DIR),,$(PWD)) ] && \
	    mkdir -p $(BUILDDIR)$(subst $(MAKEFILE_DIR),,$(PWD))
	$(VERBOSE)$(PANDOC) $(SLIDES_OPTIONS) $< -o $(subst $(MAKEFILE_DIR),$(BUILDDIR),$(@))

%.pdf: %.md $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)$(PANDOC) -f markdown $< -o $@
