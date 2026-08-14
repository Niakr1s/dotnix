#!/usr/bin/env bash

usage() {
  cat << EOF
Usage:
  $0 [FLAGS]

Prompt Layout & Syntax:
  The script captures everything from standard input as your core content.

  * Multi-line Support: Prompts can span multiple lines naturally. Newlines are
                        automatically escaped safely into the JSON payload.
  * Commentaries:       Any line starting with '#' (or spaces followed by '#')
                        will be completely skipped. Use this for annotations.
  * Multi-Prompt (---): Separate distinct concepts with a line starting with '---'.
                        The engine will process your loop queue for each section.

Interactive Input:
  $0 -> Type prompt, then press Ctrl+D on a new line to run
  echo "my prompt" | $0  -> Pipe text directly via stdin

Available Flags:
  -h, --help        Show this help message and exit
  --with_no-people   Appends human/crowd exclusions
  --with_face        Appends highly detailed face/eyes features

Environment Variables & Defaults:
  SERVER            Host address ($SERVER_URL variant) [Default: localhost:8080]
  MODEL             Target AI generation route name    [Default: animosity_illustriousV11]
  OUTPUT_DIR        Output directory                   [Default: .]
  COUNT             Number of sequential runs to queue [Default: 1]
  CLIP_SKIP         CLIP text processing layer skip    [Default: 2]
  STEPS             Generation inference passes        [Default: 28]
  WIDTH / HEIGHT    Output dimensions                  [Default: 512x512]
  SEED              Target entropy seed (-1 is random) [Default: -1]
  CFG_SCALE         Classifier-Free Guidance weight    [Default: 5.5]
  SAMPLER_NAME      Target sampling algorithm          [Default: Euler a]
  SCHEDULER         Noise scheduling algorithm         [Default: Normal]

  POSITIVE          Pre-concatenated styling wrapper
                    [Default: masterpiece, best quality, highly detailed]
  NEGATIVE          Standard generation exclusions
                    [Default: ugly, deformed, malformed, lowres...]
EOF
}

# Terminate script immediately if a command fails
set -euo pipefail

# ==========================================
# ENVIRONMENT VARIABLES & SANE DEFAULTS
# ==========================================
SERVER="${SERVER:-localhost:8080}"
MODEL="${MODEL:-animosity_illustriousV11}"
SERVER_URL="http://${SERVER}/sdapi/v1/txt2img"

COUNT=${COUNT:-1}
STEPS=${STEPS:-28}
WIDTH=${WIDTH:-512}
HEIGHT=${HEIGHT:-512}
SEED=${SEED:--1}
CFG_SCALE=${CFG_SCALE:-5.5}
SAMPLER_NAME="${SAMPLER_NAME:-Euler a}"
SCHEDULER="${SCHEDULER:-Normal}"
CLIP_SKIP=${CLIP_SKIP:-2}
OUTPUT_DIR=${OUTPUT_DIR:-.}

mkdir -p "$OUTPUT_DIR"
if [[ ! $? ]]; then
    exit 1
fi

# PROMPTS

# common positive prompt
POSITIVE="${POSITIVE:-masterpiece, best quality, ultra high res, 8k resolution, highly detailed}"

# common negative prompt
NEGATIVE="${NEGATIVE:-ugly, deformed, malformed, lowres, mutant, mutated, disfigured, compressed, noise, artifacts, dithering, simple, watermark, text, font, signage, collage, pixel}"

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;

    # PROMPTS
    --with_no-people)
      NEGATIVE="${NEGATIVE}, (human, person, people, crowd:1.4), (man, woman:1.3)"
      shift
      ;;
    --with_face)
      POSITIVE="${POSITIVE}, highly detailed face, beautiful face, stunningly beautiful, detailed eyes, crisp iris, symmetrical eyes"
      NEGATIVE="${NEGATIVE}, bad anatomy, bad eyes, asymmetrical eyes, crossed eyes, blurry pupils, distorted irises"
      shift
      ;;

    *)
      echo "Unknown flag option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

# positive prompt, provided by user via standard input
if [ -t 0 ]; then
    echo "Enter your generation prompt (Press Ctrl+D on a new line when finished):" >&2
fi
PROMPT="$(cat)"

SEP="----------------------------------------"

# ==========================================
# GENERATION ENGINE FUNCTION
# ==========================================
generate_image() {
  local prompt=$1

  local uuid
  uuid=$(uuidgen -7)
  local output_file="$OUTPUT_DIR/generated_${uuid}.png"
  output_file=$(realpath "$output_file")

  echo $SEP
  echo " Target Model:      $MODEL"
  echo " Server Target:     $SERVER"
  echo " Resolution:        ${WIDTH}x${HEIGHT}"
  echo " Sampler/Scheduler: $SAMPLER_NAME ($SCHEDULER)"
  echo " Steps / CFG:       $STEPS / $CFG_SCALE"
  echo " Clip Skip:         $CLIP_SKIP"
  echo " Seed Token:        $SEED"
  echo " File Tracker:      $output_file"
  echo $SEP
  echo " Prompts:"
  echo " Negative: $NEGATIVE"
  echo " Positive: $POSITIVE"
  echo " Provided: $prompt"
  echo $SEP

  local json_payload
  json_payload=$(jq -n \
    --arg m "$MODEL" \
    --arg p "$POSITIVE, $prompt" \
    --arg np "$NEGATIVE" \
    --arg s "$SAMPLER_NAME" \
    --arg sch "$SCHEDULER" \
    --argjson st "$STEPS" \
    --argjson w "$WIDTH" \
    --argjson h "$HEIGHT" \
    --argjson sd "$SEED" \
    --argjson cfg "$CFG_SCALE" \
    --argjson cs "$CLIP_SKIP" \
    '{
      model: $m,
      prompt: $p,
      negative_prompt: $np,
      steps: $st,
      width: $w,
      height: $h,
      seed: $sd,
      cfg_scale: $cfg,
      sampler_name: $s,
      scheduler: $sch,
      override_settings: {
        CLIP_stop_at_last_layers: $cs
      }
     }
  ')

  echo "Requesting generation from llama-swap..."
  local response
  response=$(curl -s -X POST "$SERVER_URL" \
    -H "Content-Type: application/json" \
    -d "$json_payload")

  if echo "$response" | grep -q '"error"'; then
      echo "Error from llama-swap orchestration layer:"
      echo "$response" | jq '.error' 2>/dev/null || echo "$response"
      exit 1
  fi

  # Extract the base64 string from the "images" array index 0 and decode it
  echo "$response" | jq -r '.images[0]' | base64 --decode > "$output_file"

  if [ -s "$output_file" ]; then
      echo "Success! Image generated safely and saved to: $output_file"

      if command -v chafa &> /dev/null; then
          echo "=== Terminal Preview ==="
          chafa --size=60x30 "$output_file"
          echo "========================"
      fi
  else
      echo "Error: Output file is empty. Generation failed."
      exit 1
  fi
}

# Parses global $PROMPT and populates a target array passed by reference
parse_prompt() {
  local -n target_array=$1  # Bash reference to the array variable passed in
  local current_buffer=""

  while IFS= read -r line || [ -n "$line" ]; do
    # Skip any line that starts with '#' (ignoring optional leading whitespace)
    if [[ "$line" =~ ^[[:space:]]*# ]]; then
      continue
    fi

    if [[ "$line" =~ ^[[:space:]]*--- ]]; then
      # Strip spaces and append non-empty buffers to our array
      local clean_prompt
      clean_prompt=$(echo "$current_buffer" | xargs)
      if [ -n "$clean_prompt" ]; then
        target_array+=("$clean_prompt")
      fi
      current_buffer=""
    else
      if [ -z "$current_buffer" ]; then
        current_buffer="$line"
      else
        current_buffer="${current_buffer}${IFS}${line}"
      fi
    fi
  done <<< "$PROMPT"

  # Don't forget the last tracked prompt remaining in the buffer stream
  local clean_final
  clean_final=$(echo "$current_buffer" | xargs)
  if [ -n "$clean_final" ]; then
    target_array+=("$clean_final")
  fi
}

# Main multi-prompt entry coordinator
generate_images() {
  local multi_prompt=()

  # Step 1: Extract individual prompts into a clean array structure
  parse_prompt multi_prompt

  # Step 2: Loop through the parsed array elements and fire batch commands
  local i=1
  while [ "$i" -le "$COUNT" ]; do
    for index in "${!multi_prompt[@]}"; do
      echo $SEP
      echo " Generation:        [$i / $COUNT]"
      echo " Progress:          [$((index + 1)) / ${#multi_prompt[@]}]"
      generate_image "${multi_prompt[$index]}"
    done
    i=$((i + 1))
  done
}

generate_images
