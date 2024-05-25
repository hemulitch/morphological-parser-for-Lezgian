analyzer=lez.analyzer.hfstol
.PHONY: check-coverage

check-coverage-stats: corpus $(analyzer) stats
	@ cd corpus; find * -name "*.txt" -print0 | xargs -0 ../stats ../$(analyzer)

check-coverage-unrecog: corpus $(analyzer) unrecog
	@ find corpus -name "*.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog.txt

check-coverage-recog: corpus $(analyzer) recog
	@ find corpus -name "*.txt" -print0 | xargs -0 ./recog $(analyzer) > recog.txt

check-coverage: corpus $(analyzer) stats unrecog
	@ echo aggregate coverage:
	@ (make -s check-coverage-stats; find corpus -name "*.txt" -exec cat {} \; | ./stats -q $(analyzer) -) | column -t
	@ echo
	@ echo unrecognised words:
	@ make -s check-coverage-unrecog | tail -n20

%.hfstol: %.hfst
	echo '?::0' | hfst-regexp2fst | hfst-repeat | hfst-compose -F $< - | hfst-minimise -E | hfst-fst2fst -w -o $@
