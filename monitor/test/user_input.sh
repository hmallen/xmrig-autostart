#!/bin/bash

TEST_INPUT=$1

echo $TEST_INPUT

if [[ -z $TEST_INPUT ]]; then
	echo "Empty!"
else
	echo "Not empty!"
fi
