.DEFAULT_GOAL := lez.analyzer.hfst

lez.analyzer.hfstol: lez.analyzer.hfst
  hfst-fst2fst -O -i $< -o $@

lez.analyzer.hfst: lez.generator.hfst
  hfst-invert $< -o $@

lez.generator.hfst: lez.lexd.hfst lez.twol.hfst 
  hfst-compose-intersect $^ -o $@

lez.lexd.hfst: lez.lexd
  lexd $< | hfst-txt2fst -o $@

lez.lexd: $(wildcard lez_*.lexd)
  cat lez_*.lexd > lez.lexd

lez.twol.hfst: lez.twol
  hfst-twolc $< -o $@

# tests
test.pass.txt: tests.csv
  awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: lez.generator.hfst test.pass.txt
  bash compare.sh $< test.pass.txt

# delete all
clean:
  rm *.hfst
  rm test.*
