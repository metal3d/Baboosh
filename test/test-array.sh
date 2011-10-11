#!/bin/bash

. $(dirname $0)/../src/baboosh.sh
. $(dirname $0)/classes/array.sh

new Array arr


arr.append foo
arr.append bar
arr.append "baz huu"



echo "Element 0 ::" $(arr.get 0)
echo "Element 2 ::" $(arr.get 2)

echo
echo "arr.toString::"
arr.toString

echo
echo "dumping arr"
arr.dump
