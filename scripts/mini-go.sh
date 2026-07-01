#!/usr/bin/env bash

set -eou pipefail

usage() {
    s=$(
        cat <<EOF
Usage:  mini-go [project-name] 

An easy way to quickly scaffold playground projects

Example:
  mini-go loops         Creates a go project in directory 'loops'
EOF
    )
    echo "$s"
}

create_main() {
    cat >main.go <<EOF
package main

import "fmt"

func main() {
    fmt.Println("hello $1")
}
EOF
}

create_makefile() {
    cat >Makefile <<EOF
BINARY := $1
BIN_DIR := bin
PREFIX ?= \$(HOME)/.local

build:
	mkdir -p \$(BIN_DIR)
	go build -o \$(BIN_DIR)/\$(BINARY) .

run:
	go run . \$(ARGS)

test:
	go test .

EOF
}

if [[ $# == 0 ]]; then
    echo "$(usage)"
    exit 0
fi

project_name=$1
echo "creating project $project_name"

mkdir "$project_name"
cd "$project_name"

go mod init "$project_name"
create_main "$1"
create_makefile "$1"

read -p "initialize and commit git repository? (Y/n) " create_git

if [[ "${create_git,,}" = "y" ]]; then
    git init
    git add -A
    git commit -m "git init"
fi

echo "ready to go"
