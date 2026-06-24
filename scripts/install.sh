#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for f in $(ls "$script_dir"); do
    if [[ $f == "install.sh" ]]; then
        continue
    fi
    tool="$script_dir/$f"
    chmod +x tool
    f=$(echo $f | sed 's/\.sh$//')
    destination="$HOME/.local/bin/$f"
    echo "copying $tool to $destination"
    cp $tool $destination
done
