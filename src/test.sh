#!/bin/bash

. ./baboosh.sh

### ---- TEST ---- ###

#code de test
OBJ=(
    function test1
    function tryself
    var      var1
)

OBJ::__init__(){
    local this=$1; shift;
    echo "Constructor found"

    if [[ x$@ != "x" ]]; then
        echo "arguments: "$@
    fi
}

OBJ::test1(){
    local this=$1; shift
    echo "youpi --> $this"
}

OBJ::tryself(){
    local this=$1; shift;
    echo $(eval $this.var1)

    eval $this.set_var1 "Autre..."

}

#create o1 object class OBJ
new OBJ o1

#set var1
o1.set_var1 "La variable qui tue"

echo ">> calling o1.test1"
o1.test1

echo ">> getting o1.var1:"
echo $(o1.var1)

echo ">> calling tryself..."
o1.tryself

echo ">> modified var1, try new call"
o1.tryself


#second object
echo ">> Create another object, with args on constucutor"
new OBJ o2 "arg1" "aeg2"

