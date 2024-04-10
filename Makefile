.DEFAULT_GOAL := noun.analizer.hfst
  
# generate analizer and generator
noun.analizer.hfst: noun.generator.hfst
        hfst-invert $< -o $@
noun.generator.hfst: noun.morphotactics.hfst noun.twol.hfst
        hfst-compose-intersect $^ -o $@
noun.morphotactics.hfst: noun.lexd.hfst noun.morphotactics.twol.hfst
        hfst-invert $< | hfst-compose-intersect - noun.morphotactics.twol.hfst | hfst-invert -o $@
noun.lexd.hfst: noun.lexd
        lexd $< | hfst-txt2fst -o $@
noun.twol.hfst: noun.twol
        hfst-twolc $< -o $@
noun.morphotactics.twol.hfst: noun.morphotactics.twol
        hfst-twolc $< -o $@
