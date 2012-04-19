all: alfred site

alfred: layouts.applescript
	@./build.py && cd alfred/out && zip tmp.zip * && mv tmp.zip ../../dist/Layouts.alfredextension
	@echo "Alfred Extension built"

site : docs/index.md
	@cd site && ../node_modules/.bin/markx markx.json 
	@echo "Site built"

preview-site:
	@cd site && ../node_modules/.bin/markx --preview 8001 markx.json 

preview-readme:
	@./node_modules/.bin/markx --preview 8001 README.md 

install: node_modules/markx
	git submodule update --init
	@cd site && git submodule update --init

node_modules/markx:
	npm install markx

.PHONY: preview-docs preview-readme
