#!/bin/bash
shopt -s nullglob

# transpile elm code
elm make src/Main.elm

# inject links to css files
for f in style/*.css
do
    sed -i "/<head>/ a <link href='$f' rel='stylesheet' type='text/css'>" index.html
done
