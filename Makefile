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
	@source $$(dirname $(MAKEFILE_LIST))/scripts/functions.sh; \
	for DEMO in $(DEMOS); do \
	    echo "Splitting demo $$(basename $${DEMO} .demo)"; \
	    split $$(basename $${DEMO} .demo); \
	done; \
	echo "Generating $$(basename $@)"; \
	include $*

SOURCES=$(shell find . -maxdepth 1 -name \*.yaml -printf '%P\n' | xargs -I{} basename {} .yaml)

$(addsuffix .html,$(SOURCES)):%.html: Makefile template.html %.yaml
	@\
	TITLE="$$(yq eval '.metadata.title' $*.yaml)"; \
	SUBTITLE="$$(yq eval '.metadata.subtitle' $*.yaml)"; \
	FAVICON="$$(yq eval '.metadata.favicon' $*.yaml)"; \
	BACKGROUND_IMAGE="$$(yq eval '.metadata.background.image' $*.yaml)"; \
	BACKGROUND_SIZE="$$(yq eval '.metadata.background.size' $*.yaml)"; \
	BACKGROUND_POSITION="$$(yq eval '.metadata.background.position' $*.yaml)"; \
	EVENT="$$(yq eval '.event.name' $*.yaml)"; \
	LINK="$$(yq eval '.event.link' $*.yaml)"; \
	LOGO="$$(yq eval '.event.logo' $*.yaml)"; \
	LOGOSTYLE="$$(yq eval '.event | select(.logo_style != null) .logo_style' $*.yaml)"; \
	cat template.html \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:head/x:title" -v "$${TITLE}" \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:head/x:link[@rel='icon']/@href" -v "$${FAVICON}" \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']/@data-background" -v "$${BACKGROUND_IMAGE}" \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']/@data-background-size" -v "$${BACKGROUND_SIZE}" \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']/@data-background-position" -v "$${BACKGROUND_POSITION}" \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']//x:h1" -v "$${TITLE}" \
	| xmlstarlet ed -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']//x:h2" -v "$${SUBTITLE}" \
	>$@; \
	xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']//x:a" -v "$${EVENT}" $@; \
	xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']//x:a/@href" -v "$${LINK}" $@; \
	xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']//x:img/@src" -v "$${LOGO}" $@; \
	if test -n "$${LOGOSTYLE}"; then \
		xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" --update "/x:html/x:body//x:section[@id='title']//x:img/@style" -v "$${LOGOSTYLE}" $@; \
	fi; \
	yq eval '.slides[]' $*.yaml \
	| while read -r FILE; do \
		xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" \
			--insert '/x:html/x:body//x:section[@id="summary"]' --type elem --name section \
			--append '/x:html/x:body//x:section[@id="summary"]/preceding::section[1]' --type attr --name data-markdown --value "$${FILE}" \
			--append '/x:html/x:body//x:section[@id="summary"]/preceding::section[1]' --type attr --name data-separator --value "^---$$" \
			--append '/x:html/x:body//x:section[@id="summary"]/preceding::section[1]' --type attr --name data-separator-vertical --value "^--$$" \
			--insert '/x:html/x:body//x:section[@id="summary"]' --type text --name "" --value $$'\n' \
			$@; \
	done; \
	xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" \
	    --insert '/x:html/x:body//x:section[@id="summary"]' --type text --name "" --value $$'\n' \
		$@; \
	yq eval '.summary[] | "<li><span class=\"fa-li\"><i class=\"fa-duotone fa-" + .icon + "\"></i></span> " + .text + "</li>"' $*.yaml \
	| while read -r LINE; do \
		xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" \
			--subnode '/x:html/x:body//x:section[@id="summary"]/x:ul[@id="bullets"]' --type text --name "" --value "$${LINE}" \
			--subnode '/x:html/x:body//x:section[@id="summary"]/x:ul[@id="bullets"]' --type text --name "" --value $$'\n' \
			$@; \
	done; \
	yq eval '.events | reverse | .[] | "<p>" + (.date | tostring) + " - <a href=\"" + .homepage + "\">" + .name + "</a> " + .type + " <a href=\"" + .link + "\">" + .title + "</a></p>"' $*.yaml \
	| while read -r LINE; do \
		xmlstarlet ed --inplace -P -N x="http://www.w3.org/1999/xhtml" \
			--append '/x:html/x:body//x:section[@id="summary"]/x:h3[@id="events"]' --type text --name "" --value "$${LINE}" \
			--append '/x:html/x:body//x:section[@id="summary"]/x:h3[@id="events"]' --type text --name "" --value $$'\n' \
			$@; \
	done; \
	sed -i 's/&lt;/</g; s/&gt;/>/g' $@

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

mkdocs:
	shiv --output-file ./mkdocs --console-script mkdocs \
		mkdocs \
		mkdocs-material \
		mkdocs-material-extensions \
		pymdown-extensions \
		mkdocs-minify-plugin \
		mkdocs-macros-plugin \
		mkdocs-redirects \
		regex

.PHONY:
clean:
	@rm -fv *.final.md *.command
