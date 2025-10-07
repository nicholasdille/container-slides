SHELL   := /bin/bash
TOPICS  := $(shell find $(pwd) -type f -name \*.template.md)
DEMOS   := $(shell ls *.demo 2>/dev/null)
BASEDIR ?= "../.."
COMMIT  := $(shell git rev-parse HEAD | head -c7)
TOPICS  := $(shell find $(pwd) -type f -name \*.template.md)
IMAGES  := $(shell find $(pwd) -type f -name \*.svg -or -name \*.jpg -or -name *.png)
SLIDES  := $(shell find $(pwd) -type f -name \*.html -or -name \*.css -or -name *.js)
FONTAWESOME_NPM_TOKEN := $(shell pp fa-npm)

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

BIN      := $(HOME)/.local/bin
GOMPLATE := $(BIN)/gomplate
SASS     := $(BIN)/sass
NPM      := $(BIN)/npm
MKDOCS   := $(BIN)/mkdocs

$(BIN)/%:
	@uniget install $*

$(addsuffix .html,$(shell find . -maxdepth 1 -name \*.yaml -printf '%P\n' | xargs -I{} basename {} .yaml)):%.html: Makefile template.html %.yaml $(GOMPLATE)
	@$(GOMPLATE) --file=template.html --datasource=talk=$*.yaml --out=$@; \
	sed -i 's/&lt;/</g; s/&gt;/>/g' $@

.PHONY:
init:
	@env FONTAWESOME_NPM_TOKEN=$(FONTAWESOME_NPM_TOKEN) $(NPM) install

.PHONY:
update:
	@env FONTAWESOME_NPM_TOKEN=$(FONTAWESOME_NPM_TOKEN) $(NPM) update

.PHONY:
audit:
	@$(NPM) audit

.PHONY:
serve: themes/fontawesome.css
	@\
	echo "****************************************************"; \
	echo "*                                                  *"; \
	echo "* Please open http://localhost to view the slides. *"; \
	echo "*                                                  *"; \
	echo "****************************************************"; \
	docker compose up --abort-on-container-exit web

themes/fontawesome.css:%.css: %.scss
	@$(SASS) $*.scss $*.css

$(addsuffix .pdf,$(shell find . -maxdepth 1 -name \*.html -printf '%P\n' | xargs -I{} basename {} .html)):%.pdf: %.html themes/fontawesome.css
	@docker compose run decktape --size=1920x1080 --load-pause=5000 --pause=1000 "http://web/$*.html" $*.pdf
	@docker compose down --remove-orphans

$(addsuffix .pdf,$(shell find . -maxdepth 1 -name \*.md -printf '%P\n' | xargs -I{} basename {} .md)):%.pdf: %.md
	@docker compose run md2pdf $*.md $*.pdf
	@docker compose down --remove-orphans

# pipx install mkdocs \
#     --pip-args "mkdocs-material mkdocs-material-extensions pymdown-extensions mkdocs-minify-plugin mkdocs-macros-plugin mkdocs-redirects regex" \
#     --force
mkdocs:
	@shiv --output-file ./mkdocs --console-script mkdocs \
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
	@docker compose down --remove-orphans
