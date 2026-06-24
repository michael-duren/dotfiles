#!/usr/bin/env bash

destination="$HOME/.local/bin/"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $script_dir

for f in $(ls "$script_dir"); do
    if [[ $f == "install.sh" ]]; then
        continue
    fi
    f=$(echo $f | sed 's/\.sh$//')
    tool="$(pwd)/$f"
    chmod +x tool
    echo "copying $tool to $destination"
    cp $tool $destination
done
