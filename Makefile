SHELL   := /bin/bash
TOPICS  := $(shell find $(pwd) -type f -name \*.template.md)
DEMOS   := $(shell ls *.demo 2>/dev/null)
BASEDIR ?= "../.."
COMMIT  := $(shell git rev-parse HEAD | head -c7)
TOPICS  := $(shell find $(pwd) -type f -name \*.template.md)
IMAGES  := $(shell find $(pwd) -type f -name \*.svg -or -name \*.jpg -or -name *.png)
SLIDES  := $(shell find $(pwd) -type f -name \*.html -or -name \*.css -or -name *.js)

.PHONY:
all:
	@for TOPIC in $(TOPICS); do \
	    make -C $$(dirname $${TOPIC}) -f $$(pwd)/Makefile $$(basename $${TOPIC} .template.md).final.md; \
	done

.PHONY:
clean-all:
	@for TOPIC in $(TOPICS); do \
	    make -C $$(dirname $${TOPIC}) -f $$(pwd)/Makefile clean; \
	done

%.final.md: %.template.md $(DEMOS)
	@source $$(dirname $(MAKEFILE_LIST))/functions.sh; \
	for DEMO in $(DEMOS); do \
	    echo "Splitting demo $$(basename $${DEMO} .demo)"; \
	    split $$(basename $${DEMO} .demo); \
	done; \
	echo "Generating $$(basename $@)"; \
	include $*

.PHONY:
web-$(COMMIT):
	@\
	if docker image ls web:$(COMMIT) | tr -s ' ' | grep -q "web $(COMMIT)"; then \
		:; \
	else \
		DOCKER_BUILDKIT=1 docker build --tag web:$(COMMIT) --load .; \
	fi

%.pdf: %.html web-$(COMMIT)
	@\
	echo "### Remove containers"; \
	docker ps --filter name=web --all --quiet | xargs -r docker rm -f; \
	docker ps --filter name=slides --all --quiet | xargs -r docker rm -f; \
	echo "### Run web server"; \
	docker run -d --name web web:$(COMMIT); \
	echo "### Create slides"; \
	docker run -it --network container:web --name slides astefanutti/decktape:3 --size 1920x1080 --load-pause 5000 --pause 1000 http://localhost:80/$*.html $*.pdf; \
	echo "### Copy slides"; \
	docker cp slides:/slides/$*.pdf .; \
	echo "### Remove containers"; \
	docker ps --filter name=web --all --quiet | xargs -r docker rm -f; \
	docker ps --filter name=slides --all --quiet | xargs -r docker rm -f

.PHONY:
media/fontawesome-pro@%:
	@\
	mkdir -p $@/css $@/webfonts; \
	curl -so $@/css/all.min.css https://cdn.dille.name/fontawesome-pro@$*/css/all.min.css; \
	for style in brands-400 duotone-900 light-300 regular-400 solid-900 thin-100; do \
		curl -so $@/webfonts/fa-$${style}.woff2 https://cdn.dille.name/fontawesome-pro@$*/webfonts/fa-$${style}.woff2; \
		curl -so $@/webfonts/fa-$${style}.ttf https://cdn.dille.name/fontawesome-pro@$*/webfonts/fa-$${style}.ttf; \
	done

.PHONY:
clean:
	@rm -fv *.final.md *.command
