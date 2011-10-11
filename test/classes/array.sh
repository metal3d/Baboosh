#!/bin/bash

#an Array class to simply manipulate lists
Array=(
    var count
    function append
    function get
    function dump
    function toString
)

#Constuctor, declares a global array
Array::__init__(){

    local this=$1; shift

    eval declare -a __GLOBAL__ARRAY__${this}

    local count=0
    local i=0

    for i in $@; do
        eval __GLOBAL__ARRAY__${this}[$count]=$i
        (( i++ ))
    done

    eval $this.set_count $i
}

#append a value to array
Array::append(){
    local this=$1; shift
    local count=$(eval $this.count)

    eval __GLOBAL__ARRAY__${this}[$count]=\"$@\"

    (( count++ ))
    eval $this.set_count $count
}

#get a value from given index (starting at 0)
Array::get(){
    local this=$1; shift

    local index=$1
    eval echo \${__GLOBAL__ARRAY__${this}[$index]}
    
}

#An easy dumping array view
Array::dump(){
    local this=$1; shift
    local count=$(eval $this.count)
    ((count--))
    local i=0

    echo $this  "Array("
    for i in `seq 0 $count`; do
        echo -n "    "[$i]" "
        echo \"$(eval $this.get $i)\" ""
        ((i++))
    done
    echo ")"
}

#retuen a list of quoted elements 
Array::toString(){
    local this=$1; shift
    local count=$(eval $this.count)
    ((count--))
    local i=0

    for i in `seq 0 $count`; do
        echo -n \"$(eval $this.get $i)\" ""
        ((i++))
    done
    echo
}
