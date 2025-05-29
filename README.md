# Creating the Morphological Parser for Lezgian in lexd and twol: Building a Glossing Tool 

## Parser
[/lexd](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/lexd) folder: the files with lexical material and grammatical rules 
[/twol](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/twol) folder: the files with phonological changes to accomodate inflection

all the files describing Lezgian morphology and phonology were based on grammatical descriptions by Haspelmath (1993) and Gajdarov et al. (2009)

files are compiled by running Makefile to create 4 transducers:
- `lez_analyzer_no_sep.hfstol`: takes the surface forms and gives analysis for them
- `lez_analyzer_sep.hfstol`: takes the surface forms with separators on morphemic boundaries and gives analysis for them (not frequently used)
- `lez_generator_no_sep.hfstol`: takes the analyses and generates surface forms for them
- `lez_generator_sep.hfstol`: takes the analyses and generates for them surface with separators on morphemic boundaries


## CG parser
[./cg_parser](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/cg_parser)

goal: disambiguate the morphological analysis of Lezgian text (sentence)

to start:

`make run INPUT="x"` 

where `x`:
- the path to .txt file: `make run INPUT="./corpus/nightingale.txt"`
- sentence: `make run INPUT="Чуьллера хъваз таза къайи булахар."`

the disambiguated output is saved in `disambiguated_analysis.txt`

## Metrics
[./accuracy](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/accuracy)

in this file the metrics (precision, recall, f1-score) can be calculated for two types of predictions:
- predictions made with the analyzer and filtered with CG-parser (command `make metrics`)
- predictions made with the analyzer only (command `make metrics_unfiltered_corpus`).

the gold dataset is stored [here]([the analyzer](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/accuracy/corpus_gold)). 

the average metrics for filtered texts:
| type       | precision | recall | f1 score |
| :--------- | :-------: | :----: | :------: |
| stem       |   90.63%  | 92.75% |  91.65%  |
| pos        |   77.3%   | 91.67% |  83.81%  |
| tag        |   78.32%  | 91.81% |  84.46%  |
| segments   |   88.76%  | 92.63% |  90.62%  |
| full_match |   71.83%  | 91.12% |  80.23%  |

## Coverage
[./coverage](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/coverage)

calculate coverage of the parser on preprocessed corpus
| source            | coverage1 | coverage2 |
| :---------------- | :-------: | :-------: |
| bible.txt         |   87.55%  |   64.71%  |
| khalidov.txt      |   82.69%  |   70.09%  |
| lezgi_gazet.txt   |   84.75%  |   52.2%  |
| lezgi_news.txt    |   73.62%  |   56.59%  |
| lezgi_sport.txt   |   69.03%  |   43.07%  |
| vk_corpus.txt     |   65.79%  |   43.49%  |
| web_corpus.txt    |   81.61%  |   39.87%  |
