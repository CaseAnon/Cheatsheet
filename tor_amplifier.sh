#! /bin/sh
cd /Torshammer
COUNTER=$1
THREADS=$2
TARGET=$3
i=0

while [ "$i" -lt $COUNTER ]; do
	./torshammer.py -t $TARGET -r $THREADS  -T
    	i=$((i+1))
done