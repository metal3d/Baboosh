#!/bin/bash

#include baboosh ('source' can be replaced by '.')
source $(dirname $0)/baboosh.sh

#lets create a Human
Human=(
    function eat
    function sleep
    var name
    var age
)

Human::__init__(){
    local this=$1; shift

    eval $this.set_name "$1"
    eval $this.set_age "$2"
}

Human::eat(){
    local this=$1; shift
    local name=$(eval $this.name)
    echo $name is eating now...
}

Human::sleep(){
    local this=$1; shift
    local name=$(eval $this.name)
    echo $name is sleeping now...
}

#trust me, he is human
new Human jcvd 'Jean-Claude Van Dame' 45

#call methods
jcvd.eat
jcvd.sleep

#print age
echo $(jcvd.name) is $(jcvd.age) years old

#change age...
jcvd.set_age 46

#print age
echo  Now: $(jcvd.name) is $(jcvd.age) years old
