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
    echo "Run !"
    local sleep_time=$((RANDOM/2500))
    echo "I will work for $sleep_time seconds..."
    sleep $sleep_time
    echo "Stopped !"
}

#create 2 threads
new MyThread T1
new MyThread T2

#Start threads
T1.start
T2.start

#wait each threads...
T1.join
T2.join

#and there we are...
echo "done"
exit 0
