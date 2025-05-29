import sys 
import subprocess
import pandas as pd 

def generate_forms(analysis,wordform):
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

def split_analysis(analysis):
    if "*" in analysis:
        stem, pos, tags = "", "", ""
    else:
        analysis = analysis.split("<")
        stem = analysis[0]
        pos = analysis[1].replace("<","").replace(">","")
        if len(analysis) == 2:
            tags = ""
        else:
            tags = " ".join(analysis[2:]).replace("<","").replace(">","").replace(" ",",")
    return stem, pos, tags

def parse_analysis(analysis):
    table = {'id':[],'word':[], 'predicted_stem':[], 'predicted_pos':[], 'predicted_tags':[], 'predicted_sep_form':[], 'unrecognized':[]}
    parts = analysis.split("$")
    counter = 0
    for part in parts:
        if '<punct>' not in part:
            part = part.replace("^","").strip()
            part = part.split("/")
            wordform = part[0]
            analysis = part[1:]
            if len(analysis) == 1:
                ana = analysis[0].replace("<>", "\\")
                table["id"].append(counter)
                table["word"].append(wordform)
                table["predicted_sep_form"].append(generate_forms(ana,wordform))
                stem, pos, tags = split_analysis(ana.replace("\\",""))
                table["predicted_stem"].append(stem)
                table["predicted_pos"].append(pos)
                table["predicted_tags"].append(tags)
                table["unrecognized"].append(0) # потом вручную заменяла тэги для тех токенов, которые не распознали
            else:
                for ana in analysis:
                    ana = ana.replace("<>", "\\")
                    table["id"].append(counter)
                    table["word"].append(wordform)
                    table["predicted_sep_form"].append(generate_forms(ana,wordform))
                    stem, pos, tags = split_analysis(ana.replace("\\",""))
                    table["predicted_stem"].append(stem)
                    table["predicted_pos"].append(pos)
                    table["predicted_tags"].append(tags)
                    table["unrecognized"].append(1)
            counter += 1
    return(table)
        
if __name__ == '__main__':
    with open(sys.argv[1], "r", encoding='utf-8') as f:
        analysis = f.read()
        output = parse_analysis(analysis)
        table = pd.DataFrame(output)
        table.to_csv('./output.csv',index=False)
