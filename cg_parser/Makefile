.DEFAULT_GOAL := run
INPUT ?= 

run: disambiguated_analysis.txt
	python3 script.py $^
	cat "./output.txt"

disambiguated_analysis.txt: analysis.txt rules.txt
	cat "./analysis.txt" | vislcg3 -g rules.txt | cg-conv -A > $@

analysis.txt: preprocessed.txt
	cat $^ | hfst-proc -C lez_analyzer_no_sep.hfstol > $@;

preprocessed.txt:
	@if [ -f "$(INPUT)" ]; then \
		cat "$(INPUT)" | sed -E 's/([-.!?]+)/\1\n/g' | \
		while IFS= read -r sentence || [ -n "$$sentence" ]; do \
			sentence=$$(echo "$$sentence" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$$//'); \
			if [ -n "$$sentence" ]; then \
				echo "bos $$sentence eos"; \
			fi; \
		done > $@; \
	else \
		echo "bos $(INPUT) eos" > $@; \
	fi

clean:
	rm -f preprocessed.txt analysis.txt disambiguated_analysis.txt output.txt 
