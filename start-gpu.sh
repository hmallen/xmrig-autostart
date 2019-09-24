#!/bin/bash

screen -A -m -d -S xmrig-nvidia /home/hunter/src/xmrig-nvidia/build/xmrig-nvidia \
	-l /home/hunter/.xmrig/xmrig.log --donate-level 1 -o pool.supportxmr.com:5555 \
	-u 869NJQgVEXhhfHfZipzgeRF84ZRWZLkqugbJPuZYqgaMYtsTJHtLoSbaiYkKpEdXh1W15W7kHNE7zLw5W9FqJcsFH51bskN \
	-p ChasseuR:allenhm@gmail.com -k --config=/home/hunter/.xmrig/config-nvidia.txt &
