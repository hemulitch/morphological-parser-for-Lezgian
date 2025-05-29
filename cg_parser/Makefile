.DEFAULT_GOAL := run
INPUT ?= 

run: disambiguated_analysis.txt
	cat "./disambiguated_analysis.txt"

make_table: disambiguated_analysis.txt 
	cat $< | cg-conv -A > tempfile
	python3 make_table.py tempfile
	rm -f tempfile

disambiguated_analysis.txt: analysis.txt rules.rlx
	cat "./analysis.txt" | vislcg3 -g rules.rlx | sed '/bos/d;/eos/d' > $@

analysis.txt:
	@if [ -f "$(INPUT)" ]; then \
		cat "$(INPUT)" | hfst-proc -C lez_analyzer_no_sep.hfstol > $@; \
	else \
		echo "$(INPUT)" | hfst-proc -C lez_analyzer_no_sep.hfstol > $@; \
	fi

clean:
	rm -f preprocessed.txt analysis.txt disambiguated_analysis.txt output.csv
