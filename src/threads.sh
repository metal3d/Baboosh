#!/bin/bash

. ./baboosh.sh

#Thread class
#Implements start and join method
#Each derived class MUST declare "run" method
Thread=(
    var pid
    var status
    function start
    function join
)

#Thread base class constructor
Thread::__init__(){
    local this=$1; shift

    eval $this.set_status "stopped"
    eval $this.set_pid "-1"
}


#lauch "run" method of threads
Thread::start(){
    local this=$1; shift
    local _pid=-1

    eval _cmd="$this.run"
    eval $this.run &
    _pid=$!

    eval $this.set_status "running"
    eval $this.set_pid $_pid
    
}


#Wait pid to be stopped...
Thread::join(){
    local this=$1; shift
    local _pid=$(eval $this.pid)
    _pidfile=/proc/$_pid

    while [[ -d $_pidfile ]]; do
        sleep .1
    done
    eval $this.set_status "stopped"
}
