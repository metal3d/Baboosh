#!/bin/bash


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

    local cmd="$this.run"
    eval "($cmd) &"
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
        sleep .01
    done
    eval $this.set_status "stopped"
}

#on destruction, kill child process
Thread::__kill__(){
    local this=$1; shift
    local pid=$(eval $this.pid)

    #find children of the eval launched in start method
    pids=$(ps --no-headers -o pid --ppid $pid)
    #and kill them
    for p in $pids
    do
        kill $p
    done
    #to be sure, kill eval command
    kill $pid

    #return last kill return value
    return $?
}
