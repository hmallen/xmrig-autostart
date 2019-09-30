#!/bin/bash

echo "Delay start."
#sleep 10
for i in {1..10}; do
    sleep 1
    echo $i
done
echo "Delay end."

exit