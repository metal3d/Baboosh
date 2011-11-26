#!/bin/bash

. $(dirname $0)/../src/baboosh.sh

PClass=(
    function testfunc
    function parentfunc
    function upperfunc
)

PClass::upperfunc(){
    echo "I'm the parent upper function"    
}

PClass::parentfunc(){
    echo "I'm the parent"
}

CClass=(
    extends PClass
    function testfunc
    function upperfunc
)

CClass::testfunc(){
    echo "I'm the child"    
}

CClass::upperfunc(){
    local this=$1; shift
    echo "Here is the chid upperfunc method, I will try to call parent..."
    local parent=$(eval $this.parent)
    eval $parent::upperfunc $this
}



new CClass obj1

eval obj1.testfunc
eval obj1.parentfunc
eval obj1.upperfunc

