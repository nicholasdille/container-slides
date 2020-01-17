SHELL   := /bin/bash
TOPICS  := $(shell find $(pwd) -type f -name \*.template.md)
DEMOS   := $(shell ls *.demo 2>/dev/null)
BASEDIR ?= "../.."

.PHONY:
all:
	@for TOPIC in $(TOPICS); do \
	    make -C $$(dirname $${TOPIC}) -f $$(pwd)/Makefile $$(basename $${TOPIC} .template.md).final.md; \
	done

%.final.md: %.template.md $(DEMOS)
	@source $$(dirname $(MAKEFILE_LIST))/functions.sh; \
	for DEMO in $(DEMOS); do \
	    split $$(basename $${DEMO} .demo); \
	done; \
	include $*

.PHONY:
clean:
	@rm -f *.final.md *.command
