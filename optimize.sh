#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(dirname "$0")"
OUT_DIR="$SRC_DIR/ppt-backgrounds"
QUALITY=92
TARGET_W=1920
TARGET_H=1080

# Mirror folder structure (auto-discover, exclude hidden dirs and output dir)
while IFS= read -r -d '' dir; do
  name="$(basename "$dir")"
  [ "$name" = "optimized" ] && continue
  mkdir -p "$OUT_DIR/$name"
done < <(find "$SRC_DIR" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -print0 | sort -z)

total_orig=0
total_opt=0

process_jpeg() {
  local src="$1"
  local rel="${src#$SRC_DIR/}"
  local dst="$OUT_DIR/$rel"

  magick "$src" \
    -resize "${TARGET_W}x${TARGET_H}^" \
    -gravity Center \
    -extent "${TARGET_W}x${TARGET_H}" \
    -quality "$QUALITY" \
    "$dst"

  orig=$(stat -c%s "$src")
  opt=$(stat -c%s "$dst")
  saving=$(( (orig - opt) * 100 / orig ))
  printf "  %-70s %5dK → %4dK  (-%d%%)\n" \
    "$(basename "$src")" \
    "$(( orig / 1024 ))" \
    "$(( opt / 1024 ))" \
    "$saving"

  total_orig=$(( total_orig + orig ))
  total_opt=$(( total_opt + opt ))
}

echo "Optimizing JPEGs → $OUT_DIR (quality=$QUALITY, ${TARGET_W}x${TARGET_H})"
echo "─────────────────────────────────────────────────────────────────────────────────────"

while IFS= read -r -d '' f; do
  process_jpeg "$f"
done < <(find "$SRC_DIR" \
  -not -path "$SRC_DIR/.git/*" \
  -not -path "$OUT_DIR/*" \
  \( -name "*.jpeg" -o -name "*.jpg" \) \
  -print0 | sort -z)

# Copy video files as-is (already PPT-safe)
while IFS= read -r -d '' f; do
  rel="${f#$SRC_DIR/}"
  dst="$OUT_DIR/$rel"
  mkdir -p "$(dirname "$dst")"
  cp "$f" "$dst"
  echo "  (MP4 copied as-is — $(basename "$f"))"
done < <(find "$SRC_DIR" \
  -not -path "$SRC_DIR/.git/*" \
  -not -path "$OUT_DIR/*" \
  -name "*.mp4" \
  -print0)

echo "─────────────────────────────────────────────────────────────────────────────────────"
if (( total_orig > 0 )); then
  total_saving=$(( (total_orig - total_opt) * 100 / total_orig ))
  printf "  Total: %dMB → %dMB  (-%d%%)\n" \
    "$(( total_orig / 1048576 ))" \
    "$(( total_opt / 1048576 ))" \
    "$total_saving"
fi
