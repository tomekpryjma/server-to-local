#!/bin/bash

function remote_conditionally_remove_directory
{
    local directory=$1

    if [ -d "${directory}" ]; then
        rm -r "${directory}"
    fi
}