#!/usr/bin/env bash
# DO NOT INSTALL

# these are just random bash notes as i get better
# at it
# -- tells bash everything after are arguments so don't
# parse -test.sh as an option
# ex: dirname -- -test.sh
#
# 

# echo $(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

read -p "initialize and commit git repository? (Y/n) " create_git

if [[ "${create_git}" = [Yy] ]]; then
    echo "create git"
fi

echo "ready to go"
