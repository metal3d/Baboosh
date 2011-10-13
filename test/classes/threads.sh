#!/bin/bash


#Thread class
#Implements start and join method
#Each derived class MUST declare "run" method
Thread=(
    var pid
    var status
    var fifo
    var tmpdir
    function start
    function join
)

#Thread base class constructor
Thread::__init__(){
    local this=$1; shift

    eval $this.set_status "stopped"
    eval $this.set_pid "-1"

    #check a right temporary directory
    local TMP="/tmp"
    [[ -d /dev/shm ]] && TMP="/dev/shm"

    eval $this.set_tmpdir $TMP
}


#lauch "run" method of threads
Thread::start(){
    local this=$1; shift
    local _pid=-1

    local tmp=$(eval $this.tmpdir)

    local fifo=$(mktemp -u $tmp/$this.thread_pid.XXXXXXXX)
    mkfifo $fifo

    local cmd="$this.run; echo done > $fifo"
    eval "($cmd) &"
    _pid=$!


    eval $this.set_status "running"
    eval $this.set_pid $_pid
    eval $this.set_fifo $fifo
}


#Wait pid to be stopped...
Thread::join(){
    local this=$1; shift

    local fifo=$(eval $this.fifo)

    #reading fifo is blocked while subshell is not stopped
    cat $fifo | :
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

Thread::__delete__(){
    local this=$1; shift
    #remove fifos...
    local fifo=$(eval $this.fifo)
    rm -f $fifo
}
