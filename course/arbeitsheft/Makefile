# The full path to the Makefile
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
# The path to the directory of the Makefile
MAKEFILE_DIR := $(dir $(MAKEFILE_PATH))

.PHONY: all
all: arbeitsheft.pdf

include $(MAKEFILE_DIR)/../common.mk
