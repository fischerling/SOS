# The full path to the Makefile
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
# The path to the directory of the Makefile
MAKEFILE_DIR := $(dir $(MAKEFILE_PATH))

LATEX_BASE := $(MAKEFILE_DIR)
COMMON_IMAGES := $(MAKEFILE_DIR)images

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

RUBBER_OPTS := --into .build --pdf --shell-escape -I "$(LATEX_BASE)" -I "$(COMMON_IMAGES)"

LATEX_PROG ?= pdflatex
LATEX = TEXINPUTS=$(LATEX_BASE) $(LATEX_PROG)
LATEX_OPTS := -interaction=nonstopmode -shell-escape -output-directory=.build/

VERBOSE ?= @
ifeq ($(VERBOSE), @)
	RUBBER_OPTS += --quiet
	SILENCE := > /dev/null
endif

TEX_SRC := $(wildcard *.tex)
MD_SRC := $(wildcard *.md)

slides.pdf: slides.md $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)$(PANDOC) $(SLIDES_OPTIONS) $< -o $@

slides_handout.pdf: slides_handout.md $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)$(PANDOC) $(SLIDES_OPTIONS) $< -M handout -o $@

slides%.pdf: slides%.md $(wildcard slides.md) $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)$(PANDOC) $(SLIDES_OPTIONS) $< -o $@

%.pdf: %.md $(wildcard img/*) $(MAKEFILE_LIST)
	@echo "building $@"
	$(VERBOSE)$(PANDOC) -f markdown $< -o $@

.PRECIOUS: .build/%.pdf
.build/%.pdf: %.tex .FORCE $(MAKEFILE_LIST)
	@mkdir -p .build
	$(VERBOSE)rubber $(RUBBER_OPTS) --force --jobname $(@:.build/%.pdf=%) $<

%.pdf: .build/%.pdf
	@echo "built $@"
	$(VERBOSE)cp .build/$@ $@

.PHONY: .FORCE
.FORCE:
