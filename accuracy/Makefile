OUTDIR := filtered_results
OUTDIR_UNFILT := unfiltered_results

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTDIR_UNFILT):
	mkdir -p $(OUTDIR_UNFILT)

metrics:
	python3 calculate_metrics.py corpus_gold/gold_1.csv corpus_predicted/predicted_1.csv $(OUTDIR) 1 
	python3 calculate_metrics.py corpus_gold/gold_2.csv corpus_predicted/predicted_2.csv $(OUTDIR) 2 
	python3 calculate_metrics.py corpus_gold/gold_3.csv corpus_predicted/predicted_3.csv $(OUTDIR) 3 
	python3 calculate_metrics.py corpus_gold/gold_4.csv corpus_predicted/predicted_4.csv $(OUTDIR) 4 
	python3 calculate_metrics.py corpus_gold/gold_5.csv corpus_predicted/predicted_5.csv $(OUTDIR) 5 
	python3 calculate_metrics.py corpus_gold/gold_6.csv corpus_predicted/predicted_6.csv $(OUTDIR) 6 

metrics_unfiltered_corpus:
	python3 calculate_metrics.py corpus_gold/gold_1.csv corpus_unfiltered_predicted/unfilter_predicted_1.csv $(OUTDIR_UNFILT) 1 
	python3 calculate_metrics.py corpus_gold/gold_2.csv corpus_unfiltered_predicted/unfilter_predicted_2.csv $(OUTDIR_UNFILT) 2 
	python3 calculate_metrics.py corpus_gold/gold_3.csv corpus_unfiltered_predicted/unfilter_predicted_3.csv $(OUTDIR_UNFILT) 3 
	python3 calculate_metrics.py corpus_gold/gold_4.csv corpus_unfiltered_predicted/unfilter_predicted_4.csv $(OUTDIR_UNFILT) 4 
	python3 calculate_metrics.py corpus_gold/gold_5.csv corpus_unfiltered_predicted/unfilter_predicted_5.csv $(OUTDIR_UNFILT) 5 
	python3 calculate_metrics.py corpus_gold/gold_6.csv corpus_unfiltered_predicted/unfilter_predicted_6.csv $(OUTDIR_UNFILT) 6 

clean:
	rm results/*
	rm unfiltered_results/*
