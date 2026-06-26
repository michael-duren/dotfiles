#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for f in $(ls "$script_dir"); do
    if [[ $f == "install.sh" ]]; then
        continue
    fi
    tool="$script_dir/$f"
    if [[ $(head -n 2 $tool | tail -n 1) =~ "DO NOT INSTALL" ]]; then
        continue
    fi
    chmod +x "$tool"
    f=$(echo $f | sed 's/\.sh$//')
    destination="$HOME/.local/bin/$f"
    echo "copying $tool to $destination"
    cp $tool $destination
done
