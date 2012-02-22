alfred:
	./build.py && cd alfred/out && zip tmp.zip * && mv tmp.zip ../../dist/Layouts.alfredextension

site : docs/index.md 
	@markx --nohl docs/index.md | cat site/layout/head.html - site/layout/foot.html > site/index.html

preview-site:
	@markx --nohl --preview 8001 docs/index.md 

preview-readme:
	@markx --preview 8001 README.md 

.PHONY: preview-docs preview-readme
