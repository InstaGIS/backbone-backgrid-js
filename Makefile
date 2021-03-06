VERSION = $(shell cat package.json | sed -n 's/.*"version": "\([^"]*\)",/\1/p')
current_babel_eslint = $(shell cat package.json | sed -n 's/.*"babel-eslint": "\([^"]*\)",/\1/p')
current_eslint = $(shell cat package.json | sed -n 's/.*"eslint": "\([^"]*\)",/\1/p')

SHELL = /usr/bin/env bash

default: build
.PHONY: ig_backbone test build ig_backbone_bundle 

 
build: ig_backbone 	ig_backbone_bundle

version:
	@echo $(VERSION)

install: 
	npm install
	$$(npm bin)/jspm install


test:
	$$(npm bin)/karma start
	$$(npm bin)/karma start karma.modal.conf.js

update_eslint:
	@echo  -e "Current eslint is $(GREEN)$(current_eslint)$(WHITE), current babel-eslint is $(GREEN)$(current_babel_eslint)$(WHITE)" ;\
	npm remove --save-dev eslint babel-eslint ;\
	npm install --save-dev eslint babel-eslint
 

ig_backbone:
	$$(npm bin)/jspm build src dist/ig_backbone.js --format esm --skip-source-maps --skip-encode-names

ig_backbone_bundle:	
	$$(npm bin)/jspm build src dist/ig_backbone.bundle.js --format umd --skip-encode-names --global-name window --skip-source-maps 

	


update_version:
ifeq ($(shell expr "${CURRENT_MAJOR}" \> "$(NEXT_MAJOR)"),1)
	$(error "v" parameter is lower than current version ${VERSION})
endif
ifeq ($(shell expr "${CURRENT_MINOR}" \> "$(NEXT_MINOR)"),1)
	$(error "v" parameter is lower than current version ${VERSION})
endif
ifeq ($(shell expr "${CURRENT_HOTFIX}" \> "$(NEXT_HOTFIX)"),1)
	$(error "v" parameter is lower than current version ${VERSION})
endif
ifeq ($(v),)
	$(error v is undefined)
endif
ifeq (${VERSION},$(v))
	$(error v is already the current version)
endif
	@echo "Current version is " ${VERSION}
	@echo "Next version is " $(v)
	sed -i s/"$(VERSION)"/"$(v)"/g package.json

check_version:
	$(eval SPLIT_VERSION = $(subst ., ,${VERSION}))
	$(eval NEXT_VERSION := $(subst ., ,${v}))
	$(eval CURRENT_MAJOR := $(word 1,$(SPLIT_VERSION)))
	$(eval CURRENT_MINOR := $(word 2,$(SPLIT_VERSION)))
	$(eval CURRENT_HOTFIX := $(word 3,$(SPLIT_VERSION)))
	$(eval NEXT_MAJOR := $(word 1,$(NEXT_VERSION)))
	$(eval NEXT_MINOR := $(word 2,$(NEXT_VERSION)))
	$(eval NEXT_HOTFIX := $(word 3,$(NEXT_VERSION)))


tag_and_push:
		git add --all
		git commit -a -m "Tag v $(v) $(m)"
		git tag v$(v)
		git push
		git push --tags

tag: build release

release: test check_version update_version tag_and_push	
