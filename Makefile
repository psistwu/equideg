# sample makefile
doc:
	gap -A -q -T < makedocrel.g

cleandoc:
	rm -f doc/*.aux doc/*.log doc/*.dvi doc/*.ps doc/*.pdf doc/*.bbl doc/*.ilg doc/*.ind doc/*.idx doc/*.out doc/*.html doc/*.tex doc/*.pnr doc/*.txt doc/*.blg doc/*.toc doc/*.six doc/*.brf doc/*.js doc/*.css doc/*.lab

.PHONY: doc cleandoc
