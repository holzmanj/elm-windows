#!/bin/bash
set -e

SOURCE_DIRS=("Environment" "Applications/Lifelike")

elm_to_js() {
    # Args
    #   $1 - path to elm source file
    #   $2 - path to js output file
    tmp="tmp.js"
    echo "Transpiling elm code..."
    elm make --optimize --output=$tmp $1
    echo "Compressing js to $2..."
    uglifyjs $tmp --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output=$2
    echo "Done! (final size: $(stat -c %s $2 | numfmt --to=si))"
    rm $tmp
}

base_dir=$(pwd)

for dir in "${SOURCE_DIRS[@]}"; do
    cd $dir
    elm_to_js src/Main.elm "${base_dir}/scripts/$(basename $dir).min.js"
    cd $base_dir
done