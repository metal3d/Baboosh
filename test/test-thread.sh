#!/bin/bash

#import baboosh
. $(dirname $0)/../src/baboosh.sh
. $(dirname $0)/classes/threads.sh


#MyThread is a Thread based class
MyThread=(
    extends Thread
    function run
)

MyThread::run(){
    local  _r=$RANDOM
    #find a nice random value... 
    while [ $_r -gt 8 ]; do ((_r=_r-(_r/2))); done
    [[ $_r == 0 ]] && _r=1
    
    #information
    echo "I will work for $_r seconds..."
    sleep $_r
    echo "Stopped !"
}

#create 3 threads
new MyThread T1
new MyThread T2
new MyThread T3

#Start threads
T1.start
T2.start
T3.start

#wait each threads...
T1.join
T2.join
T3.join


#and there we are...
echo "done"
exit 0
