import sys
import subprocess

def generate_forms(word, analysis):
    analysis = [a.replace("<>", "\\") for a in analysis]
    if word != "eos":
        outputs = {"word": word, "analysis": []}
        for a in analysis:
            proc = subprocess.run(
                ['hfst-proc', '-q', 'lez_generator_sep.hfstol'],
                input=a + '\n',
                text=True,
                capture_output=True,
                check=True
            )
            output = proc.stdout
            output = output.split("/")
            outputs["analysis"].append({"glosses": output[0].replace("^", "").replace("\\", ""), "sep_word":output[1].replace("$\n", "")})
    else:
        outputs = {"word": "", "analysis": [{"glosses":"", "sep_word":""}]}
    return outputs

def process_file(analysis):
    final_output = ""
    for ana in analysis:
        ana = ana.split("/")
        word = ana[0]
        ana = ana[1:]
        if word != "":
            output = generate_forms(word, ana)
            final_output += f"{output['word']}\n"
            for a in output["analysis"]:
                final_output += f"\t{a['sep_word']} {a['glosses']}\n"
    return final_output

if __name__ == '__main__':
    with open(sys.argv[1], encoding='utf-8') as f:
        analysis = f.read().split("$")
        analysis = [a.replace("^", "") for a in analysis]
        output = process_file(analysis)
    
    with open("output.txt", "w") as f:
        f.write(output)
