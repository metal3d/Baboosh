=======
Baboosh 
=======
--------------------
Object Oriented Bash
--------------------

This is a simple bash script to include in yours to enable "pseudo oriented object" scripting method with Bash.

Stolen Idea ?
'''''''''''''

You may say "ho god, he forked oobash project and said he is the creator !" - No... in fact there are a lot of projects that tries to implement OOP in bash. I made my own, and I discovered oobash_ today. I forked it thinking I could append my bet... but my solution is too different. But that's right, I took some ideas on oobash to change my own project.

To be clear, I will try to help oobash project, but I chosen my way (another way)

.. _oobash: https://github.com/domachine/oobash

OOP in Bash ? What an idea...
'''''''''''''''''''''''''''''

It's not a bad idea... Bash is a nice scripting system to help you having maintainable little functions to call. OOP in Bash can help to be more "readable" and easily fixable. 

Keep in mind that the main goal is not to "improve" bash to transform it to a large programming system, but only to add a "pseudo object system" to help the readers.

How this could work ?
'''''''''''''''''''''

That's not very complex. the oobash_ project implements a very large system with arrays. That's right, writting OOP bash script with it is maybe easier, but my method is a bit lighter. 

My project is not as well as oobash. It uses alias to keep objects and methods.

Yes, it's tricky :) But it works, and this is what I wanted !

The real story
''''''''''''''

You wonder why I decided to write that kind of project ? Ok, I will explain. 

I'm using Xmonad, a tiling window manager. To have some monitoring values on my task bar, I'm using "dzen". This bar can show some menus, but I need to launch several dzen bars at the same time because one that have a menu **is** a menu bar... 

Because I'm mad, I decided to lauch every dzen bars into one script. I used the magic "&" statement to launch them in several subprocesses. But... when I killed the main scripts... some loops was still running. So, I used another trick => kill 0

Writing 6 functions to be launched in the script was not elegant. And a dilem appeared: should I use another scripting language or maybe I can write something to let me write that kind of script with "OOP" style. And quickly, the "aliases" idea jumped into my mind.

After some tests, I realized that my idea was not so bad... and allows me to create the "Thread" class. The story began !

Is there a philosophy ?
'''''''''''''''''''''''

Yes, I've got 2 main ideas that I try to keep in mind:

- no dependencies excepting what are installed by default in unix/linux systems (ps, gawk, sed, ...)
- to allow modularity, see ''classes'' directory in ''test'' directory

The main idea is to allow everybody to use my project with minimal requirement.

Example ?
'''''''''

Simply put "baboosh.sh" file in a directory where you will create your script. Then try something like this:

::
    

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

And yes you'll say "eval ???" - that's because Bash is restrictive (right now) and I didn't find any trick to force "aliases" to be interpreted with a dynamic part.

So, what you have to know:

- set var is made by a meta call: $objectname.set_varname
- you **must** get "this" reference ($1)
- you **must** use ''eval'' to get value into method...
- object name have no dollar "$" at name in script, this is not like "$this" in method

That's all, for now...
