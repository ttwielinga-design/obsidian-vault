#!/bin/bash
# Batch convert OneDrive/Documenten .docx and .xlsx → markdown
export PATH="$PATH:/c/Users/thoma/AppData/Local/Pandoc"

SRC="C:/Users/thoma/OneDrive/Documenten"
DST="C:/Users/thoma/OneDrive/Obsidian/ThomasVault/1-raw/documents"

mkdir -p "$DST"

total=0
success=0
fail=0

echo "=== Starting batch conversion ==="
echo ""

for file in "$SRC"/*.docx "$SRC"/*.xlsx; do
    [ -f "$file" ] || continue
    ((total++))
    basename=$(basename "$file")
    ext="${basename##*.}"
    name_noext="${basename%.*}"
    safe_name=$(echo "$name_noext" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
    outfile="$DST/${safe_name}.md"
    
    if [ "$ext" = "docx" ]; then
        fmt="docx"
    else
        fmt="xlsx"
    fi
    
    if pandoc "$file" -f "$fmt" -t gfm --wrap=none -o "$outfile" 2>/dev/null; then
        ((success++))
    else
        ((fail++))
        echo "[FAIL] $basename"
    fi
    
    # Progress every 50 files
    if [ $((total % 50)) -eq 0 ]; then
        echo "  ... $total/$((282+55)) processed ($success ok, $fail fail)"
    fi
done

echo ""
echo "=== Done ==="
echo "Total: $total | OK: $success | Failed: $fail"
