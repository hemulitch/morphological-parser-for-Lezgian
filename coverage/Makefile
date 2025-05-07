analyzer=lez_analyzer_no_sep.hfstol
.PHONY: check-coverage

check-coverage-stats: corpus $(analyzer) stats
	@ cd corpus; find * -name "*.txt" -print0 | xargs -0 ../stats ../$(analyzer)

check-coverage-unrecog: corpus $(analyzer) unrecog
	@ find corpus -name "*.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog.txt
	@ find corpus -name "khalidov.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-khalidov.txt
	@ find corpus -name "bible.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-bible.txt
	@ find corpus -name "lezgi_gazet.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-lezgi-gazet.txt
	@ find corpus -name "lezgi_news.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-lezgi-news.txt
	@ find corpus -name "lezgi_sport.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-lezgi-sport.txt
	@ find corpus -name "vk_corpus.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-vk-corpus.txt
	@ find corpus -name "web_corpus.txt" -print0 | xargs -0 ./unrecog $(analyzer) > unrecog-web-corpus.txt

check-coverage-recog: corpus $(analyzer) recog
	@ find corpus -name "*.txt" -print0 | xargs -0 ./recog $(analyzer) > recog.txt
	@ find corpus -name "khalidov.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-khalidov.txt
	@ find corpus -name "bible.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-bible.txt
	@ find corpus -name "lezgi_gazet.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-lezgi-gazet.txt
	@ find corpus -name "lezgi_news.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-lezgi-news.txt
	@ find corpus -name "lezgi_sport.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-lezgi-sport.txt
	@ find corpus -name "vk_corpus.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-vk-corpus.txt
	@ find corpus -name "web_corpus.txt" -print0 | xargs -0 ./recog $(analyzer) > recog-web-corpus.txt

check-coverage: corpus $(analyzer) stats unrecog
	@ echo aggregate coverage:
	@ (make -s check-coverage-stats; find corpus -name "*.txt" -exec cat {} \; | ./stats -q $(analyzer) -) | column -t
	@ echo
	@ echo unrecognised words:
	@ make -s check-coverage-unrecog | tail -n20

%.hfstol: %.hfst
	echo '?::0' | hfst-regexp2fst | hfst-repeat | hfst-compose -F $< - | hfst-minimise -E | hfst-fst2fst -w -o $@

clean:
	rm *.txt
