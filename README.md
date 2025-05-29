## Parser

## CG parser
[./cg_parser](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/cg_parser)

goal: disambiguate the morphological analysis of Lezgian text (sentence)

to start:

`make run INPUT="x"` 

where `x`:
- the path to .txt file: `make run INPUT="./corpus/nightingale.txt"`
- sentence: `make run INPUT="Чуьллера хъваз таза къайи булахар."`

the disambiguated output is saved in `disambiguated_analysis.txt`

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
