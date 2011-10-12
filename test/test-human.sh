#!/bin/bash

#include baboosh ('source' can be replaced by '.')
source $(dirname $0)/../src//baboosh.sh

#lets create a Human
Human=(
    function eat
    function sleep
    function die
    var name
    var age
)

Human::__init__(){
    local this=$1; shift

    eval $this.set_name "$1"
    eval $this.set_age "$2"
}

Human::die(){
    local this=$1; shift
    local name=$(eval $this.name)

    echo "hhaaarrrgg $name is dead"
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

Human::__kill__(){
    #if script is killed, human must die !
    local this=$1; shift    
    eval $this.die
}

Human::__delete__(){
    echo "When script exits, you can do whatever you want in this method"
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

echo "You have 5 seconds to kill humans by pressing CTRL+C..."
sleep 5

echo "Well ! nobody is dead"
exit 0
