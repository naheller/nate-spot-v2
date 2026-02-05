#!/bin/bash

# Credit: https://duncanlock.net/blog/2021/06/15/good-simple-bash-slugify-function/
function slugify() {
    iconv -t ascii//TRANSLIT \
    | tr -d "'" \
    | sed -E 's/[^a-zA-Z0-9]+/-/g' \
    | sed -E 's/^-+|-+$//g' \
    | tr "[:upper:]" "[:lower:]"
}

source_dir="$HOME/Documents/Notes/*.md"
dest_dir="$HOME/Projects/nate-spot-v2/html"

rm -rf "$dest_dir"
mkdir "$dest_dir"

for file in $source_dir; do
    # echo "$file"
    if [ -f "$file" ]; then
        title=$(basename "$file" .md)
        slug=$(echo $title | slugify)
        tags=$(pandoc "$file" -o html/"$slug".html --lua-filter=meta.lua --template template.html)
        echo $title
        echo $slug
    fi
done

# tags=$(pandoc "md/My First Post.md" -o html/post.html --lua-filter=meta.lua --template template.html)
# title=$(jq -r '.title' <<<"$json")
# echo "$tags"

# readarray -t meta_array < <(pandoc md/post.md --lua-filter=meta.lua)
# printf '%s\n' "${meta_array[0]}"

# IFS=',' read -a meta_list <<< "$meta_string"

# for i in "${meta_list[@]}"; do
#     echo $i
# done
#
# <!--
