#!/bin/bash
current=$((0x2400))

for i in `seq 1 100`;
do
    printf "%x  " $current
    for j in `seq 1 16`;
    do
        echo $current | awk '{ printf("%c ", $0); }'
        current=$((current+1))
    done
    echo
done

