#!/bin/bash

# Usage: ./compare_labels.sh true_labels.csv predicted_labels.csv
export LC_NUMERIC=C

csv_mode=0
if [[ "$1" == "--csv" ]]; then
  csv_mode=1
  shift
fi

true_file="$1"
pred_file="$2"

if [[ ! -f "$true_file" || ! -f "$pred_file" ]]; then
  echo "Both true and predicted files must be provided and exist."
  exit 1
fi

# Counters
total=0
full_match=0
analysis_match=0
pos_match=0
correct_segments=0
stem_match=0

# Function to extract stem (before first '<') from analysis
extract_stem() {
  local analysis="$1"
  echo "$analysis" | sed -E 's/(^[^<]+).*/\1/'
}

# Function to extract POS tags from analysis (all tags inside <>)
extract_pos_tags() {
  local analysis="$1"
  # Extract all tags inside <>
  echo "$analysis" | grep -oP '(?<=<)[^>]+(?=>)' | tr '\n' ' '
}

# Read both files line by line simultaneously, skipping headers
exec 3< <(tail -n +2 "$pred_file")
while IFS=, read -r t_word t_analysis t_sep_form <&4 && IFS=, read -r p_word p_analysis p_sep_form <&3; do

  ((total++))

  # Normalize spaces (trim)
  t_word=$(echo "$t_word" | xargs)
  t_analysis=$(echo "$t_analysis" | xargs)
  t_sep_form=$(echo "$t_sep_form" | xargs)

  p_word=$(echo "$p_word" | xargs)
  p_analysis=$(echo "$p_analysis" | xargs)
  p_sep_form=$(echo "$p_sep_form" | xargs)

  # 1) Full match: predicted analysis may have multiple predictions separated by '/'
  # Check if any predicted analysis equals true analysis exactly
  IFS='/' read -ra preds <<< "$p_analysis"
  analysis_found=0
  for pred in "${preds[@]}"; do
    if [[ "$pred" == "$t_analysis" ]]; then
      analysis_found=1
      break
    fi
  done
  ((analysis_match+=analysis_found))

  # 2) POS match: check if any predicted analysis contains the POS tag from true analysis
  # Extract POS tags from true analysis (e.g. n, verb, cop)
  # We consider POS as the first tag inside <>
  # For example: Билбил<n><abs> -> POS = n
  pos_tag=$(echo "$t_analysis" | grep -oP '(?<=<)[^>]+(?=>)' | head -1)

  pos_found=0
  for pred in "${preds[@]}"; do
    # Extract POS tags from predicted analysis
    pred_pos_tags=$(extract_pos_tags "$pred")
    # Check if pos_tag is in pred_pos_tags
    if echo "$pred_pos_tags" | grep -qw "$pos_tag"; then
      pos_found=1
      break
    fi
  done
  ((pos_match+=pos_found))

  # 3) correct_segments: sep_form match exactly
  IFS='/' read -ra preds_sep <<< "$p_sep_form"
  match_sep_form=0
  for pred_sep in "${preds_sep[@]}"; do
    if [[ "$pred_sep" == "$t_sep_form" ]]; then
      match_sep_form=1
      break
    fi
  done
  ((correct_segments+=match_sep_form))

  # 4) stem_match: stem from true analysis matches stem from any predicted analysis
  true_stem=$(extract_stem "$t_analysis")
  stem_found=0
  for pred in "${preds[@]}"; do
    pred_stem=$(extract_stem "$pred")
    if [[ "$pred_stem" == "$true_stem" ]]; then
      stem_found=1
      break
    fi
  done
  ((stem_match+=stem_found))

  full_match_found=0
  for i in "${!preds[@]}"; do
    pred="${preds[i]}"
    pred_sep="${preds_sep[i]:-}"  # corresponding sep_form, if exists
    if [[ "$pred" == "$t_analysis" && "$pred_sep" == "$t_sep_form" ]]; then
      full_match_found=1
      break
    fi
  done

  ((full_match+=full_match_found))

done 4< <(tail -n +2 "$true_file")

# Output formatting based on mode
if (( csv_mode )); then
  printf "%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n" \
    "$(echo "scale=4; 100 * $full_match / $total" | bc)" \
    "$(echo "scale=4; 100 * $analysis_match / $total" | bc)" \
    "$(echo "scale=4; 100 * $pos_match / $total" | bc)" \
    "$(echo "scale=4; 100 * $correct_segments / $total" | bc)" \
    "$(echo "scale=4; 100 * $stem_match / $total" | bc)"
else
  # Original human-readable output
  echo "Total entries: $total"
  echo "Full match count: $full_match"
  echo "Analysis match count: $analysis_match"
  echo "POS match count: $pos_match"
  echo "Correct segments count: $correct_segments"
  echo "Stem match count: $stem_match"
  
  printf "Full match accuracy: %.2f%%\n" "$(echo "scale=4; 100 * $full_match / $total" | bc)"
  printf "Analysis match accuracy: %.2f%%\n" "$(echo "scale=4; 100 * $analysis_match / $total" | bc)"
  printf "POS match accuracy: %.2f%%\n" "$(echo "scale=4; 100 * $pos_match / $total" | bc)"
  printf "Correct segments accuracy: %.2f%%\n" "$(echo "scale=4; 100 * $correct_segments / $total" | bc)"
  printf "Stem match accuracy: %.2f%%\n" "$(echo "scale=4; 100 * $stem_match / $total" | bc)"
fi
