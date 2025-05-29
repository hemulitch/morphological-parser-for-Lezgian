import sys 
import subprocess
import pandas as pd 

def normalize_tags(tag_str):
    if pd.isna(tag_str) or tag_str.strip() == "":
        return ""
    parts = [t.strip() for t in tag_str.split(",")]
    return ", ".join(sorted(set(p for p in parts if p)))

def calculate_metrics(gold_path, pred_path, out_dir, prefix):
    # 1) Load
    gold = pd.read_csv(gold_path)\
             .rename(columns={"id":"id", "stem":"stem", "pos":"pos", "tags":"tags", "sep_form":"sep_form"})
    preds = pd.read_csv(pred_path)\
               .rename(columns={"id":"id",
                                "predicted_stem":"pred_stem",
                                "predicted_pos":"pred_pos",
                                "predicted_tags":"pred_tags",
                                "predicted_sep_form":"pred_sep_form",
                                "unrecognized":"unrecognized"})

    # 2) Normalize both tag columns
    gold["tags"] = gold["tags"].apply(normalize_tags)
    preds["pred_tags"] = preds["pred_tags"].apply(normalize_tags)

    # 3) Merge on token id
    df = preds.merge(gold, how="left", on="id")

    # 4) Compute boolean checks
    df["check_stem"] = (df["stem"] == df["pred_stem"]).astype(float)
    df["check_pos"]  = (df["pos"]  == df["pred_pos"]).astype(float)
    df["check_tags"] = (df["tags"] == df["pred_tags"]).astype(float)
    df["check_sep_form"] = (df["sep_form"] == df["pred_sep_form"]).astype(float)
    df["check_all"]  = ((df[["check_stem","check_pos","check_tags","check_sep_form"]].sum(axis=1) == 4)
                        .astype(float))

    # 5) Cast unrecognized to int (1 = false-negative for everything)
    df["unrecognized"] = df["unrecognized"].astype(int)
   
    # dump matches & mismatches
    df.to_csv(f"{out_dir}/{prefix}_results.csv", index=False)

    # 6) Aggregate counts and compute metrics
    summary = []
    for key in [("stem","check_stem"), ("pos","check_pos"), ("tags","check_tags"), ("sep_form","check_sep_form"), ("all","check_all")]:
        name, col = key
        TP = df[col].sum()
        FN = df["unrecognized"].sum()
        FP = ((df[col] == 0) & (df["unrecognized"] == 0)).sum()

        prec = TP / (TP + FP) if (TP + FP) > 0 else 0.0
        rec  = TP / (TP + FN) if (TP + FN) > 0 else 0.0
        f1   = 2 * prec * rec / (prec + rec) if (prec + rec) > 0 else 0.0

        summary.append({
            "type":    name,
            "precision": prec,
            "recall":    rec,
            "F1":        f1
        })

    return pd.DataFrame(summary).set_index("type")

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print("Usage: python accuracy.py gold_N.csv predicted_N.csv output_dir N")
        sys.exit(1)
    texts_names = {
        '1': 'congress_in_belizh.txt',
        '2': 'early_text_in_latin.txt',
        '3': 'nightingale.txt',
        '4': 'the_flower_from_russia.txt',
        '5': 'the_magpie_and_the_wolf.txt',
        '6': 'who_is_stealing_the_melons.txt'
        }
    gold_csv, pred_csv, output_dir, prefix = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
    output = calculate_metrics(gold_csv, pred_csv, output_dir, prefix)
    if prefix in texts_names:
        print(texts_names[prefix])
    print(output)
    
