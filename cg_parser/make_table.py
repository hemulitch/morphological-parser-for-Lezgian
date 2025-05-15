import sys 
import subprocess
import pandas as pd 

def generate_forms(analysis,wordform):
    """
    generating segmented forms from an analysis using lez_generator_sep.hfstol.
    returns generated form or "ERROR" is no forms can be generated.
    """
    try:
        proc = subprocess.run(
            ['hfst-proc', '-q', 'lez_generator_sep.hfstol'],
            input=analysis + '\n',
            text=True,
            capture_output=True,
            check=True
        )
        output = proc.stdout.split("/")[1:]
        if len(output) > 1:
            for out in output:
                out = out.replace("$\n", "")
                if out.replace("-", "").lower() == wordform.lower():
                    output = out
                    break
        else:
            output = output[0].replace("$\n", "")
    except subprocess.CalledProcessError:
        output = "ERROR"
    return output

def parse_analysis(analysis):
    """
    making a table from disambiguated output of cg parser for further evaluation (accuracy)
    returns table in format word,analysis,sep_form
    """
    table = {'word':[],'analysis':[],'sep_form':[]}
    parts = analysis.split("$")
    for part in parts:
        part = part.replace("^", "").strip()
        part = part.split("/")
        wordform = part[0]
        analysis = part[1:]
        analysis_clean = []
        segmented_forms = []
        for ana in analysis:
            if "*" in ana:
                analysis_clean.append("")
                segmented_forms.append("")
            else:
                ana = ana.replace("<>", "\\")
                analysis_clean.append(ana.replace("\\",""))
                segments = generate_forms(ana,wordform)
                segmented_forms.append(segments)
        table['word'].append(wordform)
        table['analysis'].append("/".join(analysis_clean))
        table['sep_form'].append("/".join(segmented_forms))
    return table

        
if __name__ == '__main__':
    with open(sys.argv[1], "r", encoding='utf-8') as f:
        analysis = f.read()
        output = parse_analysis(analysis)
        table = pd.DataFrame(output)
        table.to_csv('./output.csv',index=False)
