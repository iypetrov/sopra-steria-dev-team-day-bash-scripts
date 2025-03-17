#!/bin/bash

# cat data.csv
# cat data.csv | cut -d ',' -f -5
# cat data.csv | cut -d ',' -f -5 | tail -n +2

while read line; do
    type="$(echo "${line}" | cut -d ',' -f 3)"
    # if [[ "${type}" == "Electronics" ]]; then
    #     echo "${line}"
    # fi
    
    if echo "${line}" | grep -qs "Electronics"; then
        echo "${line}" 
    fi
done < <(cat data.csv | cut -d ',' -f -5 | tail -n +2)
