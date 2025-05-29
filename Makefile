.DEFAULT_GOAL := all

all: lez_analyzer_no_sep.hfstol lez_analyzer_sep.hfstol lez_generator_no_sep.hfstol lez_generator_sep.hfstol

lez_analyzer_no_sep.hfstol: lez_analyzer_no_sep.hfst
	hfst-fst2fst -O -i $< -o $@

lez_analyzer_sep.hfstol: lez_analyzer_sep.hfst
	hfst-fst2fst -O -i $< -o $@

lez_generator_no_sep.hfstol: lez_generator_no_sep.hfst
	hfst-fst2fst -O -i $< -o $@

lez_generator_sep.hfstol: lez_generator_sep.hfst
	hfst-fst2fst -O -i $< -o $@

lez_analyzer_sep.hfst: lez_generator_sep.hfst
	hfst-invert $< -o $@

lez_analyzer_no_sep.hfst: lez_generator_no_sep.hfst
	hfst-invert $< -o $@

lez_generator_sep.hfst: lez.hfst lez_sep.twol.hfst
	hfst-compose-intersect $^ | hfst-minimize -o $@

lez_generator_no_sep.hfst: lez.hfst lez_no_sep.twol.hfst
	hfst-compose-intersect $^ | hfst-minimize -o $@

lez.hfst: lez__.hfst lez_add_rules2.twol.hfst
	hfst-compose-intersect $^ | hfst-minimize -o $@

lez__.hfst: lez_.hfst lez_add_rules1.twol.hfst
	hfst-compose-intersect $^ | hfst-minimize -o $@

lez_.hfst: lez.lexd lez.twol.hfst
	lexd $< | hfst-txt2fst | hfst-compose-intersect lez.twol.hfst -o $@

lez.lexd: $(wildcard lexd/lez_*.lexd)
	cat lexd/lez_*.lexd > lez.lexd

lez.twol.hfst: twol/lez_original.twol
	hfst-twolc $< -o $@

lez_sep.twol.hfst: twol/lez_sep.twol
	hfst-twolc $< -o $@

lez_no_sep.twol.hfst: twol/lez_no_sep.twol
	hfst-twolc $< -o $@

lez_add_rules1.twol.hfst: twol/lez_add_rules1.twol
	hfst-twolc $< -o $@

lez_add_rules2.twol.hfst: twol/lez_add_rules2.twol
	hfst-twolc $< -o $@

# tests
test.pass.txt: tests.csv
	awk -F, '$$4 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
test2.pass.txt: tests.csv
	awk -F, '$$4 == "pass" {print $$1 ":" $$3}' $^ | sort -u > $@

check: lez_generator_no_sep.hfst test.pass.txt
	bash compare.sh $< test.pass.txt
check_sep: lez_generator_sep.hfst test2.pass.txt
	bash compare.sh $< test2.pass.txt
# delete all
clean:
	rm *.hfst
	rm *.hfstol
	rm test.*
