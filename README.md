## Parser

## Coverage
[./coverage](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/coverage)

## CG parser
[./cg_parser](https://github.com/hemulitch/morphological-parser-for-Lezgian/tree/main/cg_parser)

goal: disambiguate the morphological analysis of Lezgian text (sentence)

to start:

`make run INPUT="x"` 

where `x`:
- the path to .txt file: `make run INPUT="./corpus/nightingale.txt"`
- sentence: `make run INPUT="Чуьллера хъваз таза къайи булахар."`

the disambiguated output is saved in `output.txt`
