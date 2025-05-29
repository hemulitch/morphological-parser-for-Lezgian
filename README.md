## Parser
in `/lexd` folder the files with dictionary and grammatical rules are stored
in `/twol` folder the files with phonological changes are stored
they are compiled by running Makefile to create 4 transducers:
- `lez_analyzer_no_sep.hfstol`
- `lez_analyzer_sep.hfstol`
- `lez_generator_no_sep.hfstol`
- `lez_generator_sep.hfstol`
- 
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
in this file the metrics (precision, recall, f1-score) can be calculated for predictions of the analyzer filtered with CG-parser (command `make metrics`) and not filtered with CG-parser (command `make metrics_unfiltered_corpus`). the gold dataset is stored here. 

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
