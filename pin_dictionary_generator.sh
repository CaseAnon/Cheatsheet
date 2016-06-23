#!/bin/bash

# Simple example of a dictionary generator for a 3 number pin

for i in 0 1 2 3 4 5 6 7 8 9
do
for j in 0 1 2 3 4 5 6 7 8 9
do
for k in 0 1 2 3 4 5 6 7 8 9
do
echo $i$j$k >> pin3
done
done
done