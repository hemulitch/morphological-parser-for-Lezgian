.DEFAULT_GOAL := run
INPUT ?= 

run: disambiguated_analysis.txt
	python3 script.py $^
	cat "./output.txt"

disambiguated_analysis.txt: analysis.txt rules.txt
	cat "./analysis.txt" | vislcg3 -g rules.txt | cg-conv -A > $@

analysis.txt:
	@echo "generating analysis.txt from input: $(INPUT)"
	@if [ -f "$(INPUT)" ]; then \
		cat "$(INPUT)" | hfst-proc -C lez_analyzer_no_sep.hfstol > $@; \
	else \
		echo "$(INPUT)" | hfst-proc -C lez_analyzer_no_sep.hfstol > $@; \
	fi

clean:
	rm -f analysis.txt disambiguated_analysis.txt output.txt 
