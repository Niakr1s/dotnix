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
  -h, --help         Show this help message and exit
Prompts:
  --neg              Appends sane defaults negatives
  --pos              Appends sane defaults positives
  --with_no-people   Appends human/crowd exclusions
  --with_face        Appends highly detailed face/eyes features
Preset:
  --preset [ sdxl | flux1 ]
    Set preconfigured values (SAMPLER, SCHEDULER, STEPS, CFG, CLIP)

Environment Variables & Defaults:
  MODEL             Target AI generation route name    [Default: animosity_illustriousV11]
  SERVER            Host address                       [Default: localhost:8080]

  WIDTH / W         Output image width                 [Default: 512]
  HEIGHT / H        Output image height                [Default: 512]

  SAMPLER           Target sampling algorithm
  SCHEDULER         Noise scheduling algorithm
  STEPS             Generation inference passes
  CFG               Classifier-Free Guidance weight
  CLIP              CLIP text processing layer skip

  OUT               Output directory                   [Default: ~/Pictures/imggen]
  COUNT             Number of sequential runs to queue [Default: 1]

  NEGATIVE          Standard generation exclusions
                    [Default: ugly, deformed, malformed, lowres...]
  POSITIVE          Pre-concatenated styling wrapper
                    [Default: masterpiece, best quality, highly detailed]

Resolution Guidelines:
  Illustrious:
    Training resolution: 1024x1024
    Portrait: 832x1216
    Landscape: 1216x832
    Widescreen: 1344x768
EOF
}

# Terminate script immediately if a command fails
set -euo pipefail

# ==========================================
# ENVIRONMENT VARIABLES & SANE DEFAULTS
# ==========================================
if [[ -z "$MODEL" ]]; then
    echo "MODEL not provided"
    usage
    exit 1
fi

SERVER="${SERVER:-localhost:8080}"
SERVER_URL="http://${SERVER}/sdapi/v1/txt2img"

WIDTH=${WIDTH:-${W:-512}}
HEIGHT=${HEIGHT:-${H:-512}}

PRESET_SET=false
preset() {
    case "$1" in
        default)
            SAMPLER="${SAMPLER:-Euler a}"
            SCHEDULER="${SCHEDULER:-Discrete}"
            STEPS="${STEPS:-20}"
            CFG="${CFG:-7.0}"
            CLIP="${CLIP:-0}"
        ;;
        sdxl)
            SAMPLER="${SAMPLER:-Euler a}"
            SCHEDULER="${SCHEDULER:-Normal}"
            STEPS="${STEPS:-28}"
            CFG="${CFG:-5.5}"
            CLIP="${CLIP:-2}"
        ;;
        flux1)
            SAMPLER="${SAMPLER:-Euler}"
            SCHEDULER="${SCHEDULER:-Discrete}"
            STEPS="${STEPS:-28}"
            CFG="${CFG:-1.0}"
            CLIP="${CLIP:-0}"
        ;;
        *)
            echo "Error: unkown preset"
            useage
            exit 1
    esac
    PRESET_SET=true
}

NEGATIVE="${NEGATIVE:-}"
POSITIVE="${POSITIVE:-}"

OUT=${OUT:-~/Pictures/imggen}
COUNT=${COUNT:-1}

mkdir -p "$OUT"
if [[ ! $? ]]; then
    exit 1
fi

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;

    # PRESET
    --preset)
      shift
      preset "$1"
      shift
      ;;

    # PROMPTS
    --neg)
      NEGATIVE="${NEGATIVE}, ugly, deformed, malformed, lowres, mutant, mutated, disfigured, compressed, noise, artifacts, dithering, simple, watermark, text, font, signage, collage, pixel"
      shift
      ;;
    --pos)
      POSITIVE="${POSITIVE}, masterpiece, best quality, ultra high res, 8k resolution, highly detailed"
      shift
      ;;
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

if [ "$PRESET_SET" != true ]; then
    preset "default"
fi

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
  local prompt="$1"
  local output_file="$2"

  local json_payload
  json_payload=$(jq -n \
    --arg m "$MODEL" \
    --argjson w "$WIDTH" \
    --argjson h "$HEIGHT" \
    --arg s "$SAMPLER" \
    --arg sch "$SCHEDULER" \
    --argjson st "$STEPS" \
    --argjson cfg "$CFG" \
    --argjson cs "$CLIP" \
    --arg np "$NEGATIVE" \
    --arg p "$POSITIVE, $prompt" \
    '{
      model: $m,
      width: $w,
      height: $h,
      sampler_name: $s,
      scheduler: $sch,
      steps: $st,
      cfg_scale: $cfg,
      override_settings: {
        CLIP_stop_at_last_layers: $cs
      },
      seed: -1,
      negative_prompt: $np,
      prompt: $p
     }
  ')

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


}

# Parses global $PROMPT and populates a target array passed by reference
parse_prompt() {
  local -n target_array=$1
  local current_buffer=""
  local skipping=false

  while IFS= read -r line || [ -n "$line" ]; do
    # If we encounter a delimiter, reset skipping state and handle the buffer
    if [[ "$line" =~ ^[[:space:]]*--- ]]; then
      # Only save the buffer if we weren't just in a skip block
      if [ "$skipping" = false ]; then
        local clean_prompt
        clean_prompt=$(echo "$current_buffer" | xargs)
        if [ -n "$clean_prompt" ]; then
          target_array+=("$clean_prompt")
        fi
      fi
      skipping=false
      current_buffer=""
      continue
    fi

    # If currently in a skip block, ignore the line
    if [ "$skipping" = true ]; then
      continue
    fi

    # Check for the start of a multi-line skip block
    if [[ "$line" =~ ^[[:space:]]*### ]]; then
      # CRITICAL: Save the completed prompt before entering skip mode
      local clean_prompt
      clean_prompt=$(echo "$current_buffer" | xargs)
      if [ -n "$clean_prompt" ]; then
        target_array+=("$clean_prompt")
      fi

      skipping=true
      current_buffer=""
      continue
    fi

    # Skip single-line comments starting with a single '#' (but not '###')
    if [[ "$line" =~ ^[[:space:]]*# ]]; then
      continue
    fi

    # Append valid lines to the buffer
    if [ -z "$current_buffer" ]; then
      current_buffer="$line"
    else
      current_buffer="${current_buffer}${IFS}${line}"
    fi
  done <<< "$PROMPT"

  # Append final buffer if not currently in a skip block
  if [ "$skipping" = false ]; then
    local clean_final
    clean_final=$(echo "$current_buffer" | xargs)
    if [ -n "$clean_final" ]; then
      target_array+=("$clean_final")
    fi
  fi
}


generate_output_filepath() {
  local uuid
  uuid=$(uuidgen -7)
  local output_file="$OUT/generated_${uuid}.png"
  output_file=$(realpath "$output_file")
  echo "$output_file"
}

# Main multi-prompt entry coordinator
generate_images() {
  local multi_prompt=()

  # Step 1: Extract individual prompts into a clean array structure
  parse_prompt multi_prompt

  # Step 2: Loop through the parsed array elements and fire batch commands
  echo $SEP
  echo " MODEL:        $MODEL"
  echo " SERVER:       $SERVER"
  echo " WIDTH:        $WIDTH"
  echo " HEIGHT:       $HEIGHT"
  echo " SAMPLER:      $SAMPLER"
  echo " SCHEDULER:    $SCHEDULER"
  echo " STEPS:        $STEPS"
  echo " CFG:          $CFG"
  echo " CLIP:         $CLIP"
  echo ""
  echo " NEGATIVE: $NEGATIVE"
  echo " POSITIVE: $POSITIVE"
  echo $SEP

  local i=1
  while [ "$i" -le "$COUNT" ]; do
    for index in "${!multi_prompt[@]}"; do
      local prompt
      prompt="${multi_prompt[$index]}"
      local output_filepath
      output_filepath="$(generate_output_filepath)"

      echo $SEP
      echo " Batch:    [$i / $COUNT]"
      echo " Prompt:   [$((index + 1)) / ${#multi_prompt[@]}]"
      echo ""
      echo " Generating: $prompt"
      echo ""

      generate_image "$prompt" "$output_filepath"

      if [ ! -s "$output_filepath" ]; then
          echo "Error: Output file is empty. Generation failed."
          exit 1
      fi

      echo " Output: $output_filepath"
      if command -v chafa &> /dev/null; then
          echo ""
          chafa --size=60x30 "$output_filepath"
      fi
      echo $SEP
    done

    i=$((i + 1))
  done
}

generate_images
