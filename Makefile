.DEFAULT_GOAL := numerals.analizer.hfst


numerals.analizer.hfst: numerals.generator.hfst
	hfst-invert $< -o $@

numerals.generator.hfst: numerals.lexd.hfst numerals.twol.hfst
	hfst-compose-intersect $^ -o $@

numerals.lexd.hfst: numerals2.lexd
	lexd $< | hfst-txt2fst -o $@

numerals.twol.hfst: numerals.twol
	hfst-twolc $< -o $@

test.pass.txt: tests.csv
	awk -F '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: numerals.generator.hfst test.pass.txt
	bash compare.sh $< text.pass.txt

test.clean: check
	rm test.*
