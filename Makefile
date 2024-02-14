numerals.analyzer.hfst: numerals.generator.hfst
	hfst-invert numerals.generator.hfst -o numerals.analyzer.hfst

numerals.generator.hfst: numerals2.lexd
	lexd numerals2.lexd | hfst-txt2fst -o numerals.generator.hfst
