GOLD_DIR=corpus_gold
PRED_DIR=corpus_predicted
SCRIPT=./accuracy.sh

INDICES := $(shell ls $(GOLD_DIR)/gold_*.csv | xargs -n1 basename | sed 's/^gold_//' | sed 's/\.csv$$//')

RESULTS=results.tsv

.PHONY: all clean summary

all: $(RESULTS) summary

$(RESULTS): $(foreach i,$(INDICES),$(GOLD_DIR)/gold_$(i).csv) $(SCRIPT)
	@echo "source  full_acc  ana_acc  pos_acc  seg_acc  stem_acc"
	@for i in $(INDICES); do \
		echo -n "$$i\t" >> $@; \
		$(SCRIPT) --csv $(GOLD_DIR)/gold_$$i.csv $(PRED_DIR)/predicted_$$i.csv >> $@; \
	done

summary: $(RESULTS)
	@echo
	@column -t -s $$'\t' $(RESULTS)
	@echo
	@awk -F'\t' 'NR>1 {for(i=2;i<=NF;i++) sum[i]+=$$i; count++} END {printf "avg"; for(i=2;i<=NF;i++) printf "\t%.2f", sum[i]/count; print ""}' $(RESULTS)

clean:
	rm -f $(RESULTS)
