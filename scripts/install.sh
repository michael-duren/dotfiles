#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MACOS="false"
if [[ $# > 0 ]]; then
    if [[ $1 == "mac" ]]; then
        MACOS="true"
    fi
fi

for f in $(ls "$script_dir"); do
    if [[ $f == "install.sh" ]]; then
        continue
    fi
    tool="$script_dir/$f"
    if [[ $(head -n 2 $tool | tail -n 1) =~ "DO NOT INSTALL" ]]; then
        continue
    fi
    if [[ "$MACOS" == "true" ]] && [[ ! $(head -n 3 $tool | tail -n 1) =~ "MAC_OS" ]]; then
        continue
    fi
    chmod +x "$tool"
    f=$(echo $f | sed 's/\.sh$//')
    destination="$HOME/.local/bin/$f"
    echo "copying $tool to $destination"
    cp $tool $destination
done
