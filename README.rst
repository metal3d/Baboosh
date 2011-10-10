============================
Baboosh Object Oriented Bash
============================

This is a simple bash script to include in yours to enable "pseudo oriented object" scripting method with Bash.

Stolen Idea ?
'''''''''''''

You may say "ho god, he forked oobash project and said he is the creator !" - No... in fact there are a lot of projects that tries to implement POO in bash. I made my own, and I discovered oobash_ today. I forked it thinking I could append my bet... but my solution is too different. But that's right, I took some ideas on oobash to change my own project.

To be clear, I will try to help oobash project, but I chosen my way (another way) on my solution.

.. _oobash: https://github.com/domachine/oobash

OOP in Bash ? What an idea...
'''''''''''''''''''''''''''''

It's not a bad idea... Bash is a nice scripting system to help you to have maintainable little functions to call. OOP in Bash can help to be more "readable" and easily fixable. 

Keep in mind that the main goal is not to "improve" bash to transform it to a large programming system, but only to add a "pseudo object system" to help the readers.

How did you made ?
''''''''''''''''''

That's not very complex. the oobash_ project implements a very large system with arrays and allows some inheritance. My project is not as well as oobash. It uses alias to keep objects and methods.

Yes, it's tricky :) But it works, and this is what I wanted !

Example ?
'''''''''

Simply put "baboosh.sh" file in a directory where you will create your script. Then try something like this:

::
    
    #!/bin/bash
    
    source $(diraname $0)/baboosh.sh
    
    #lets create a Human
    Human=(
        function eat
        function sleep
        var name
        var age
    )
    
    Human::__init__(){
        local this=$1; shift
    
        eval $this.set_name $1
        eval $this.set_age $2
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
    new Human jcvd "Jean-Claude Van Dame" 45
    jcvd.eat
    jcvd.sleep
    
    #change age...
    jcvd.set_age 46


And yes you'll say "eval ???" - that's because Bash is restrictive (right now) and I didn't find any trick to force "aliases" to be interpreted with a dynamic part.

So, what you have to know:

- set var is made by a meta call: $objectname.set_varname
- you **must** get "this" reference ($1)
- you **must** use ''eval'' to get value into method...
- object name have no dollar "$" at name in script, this is not like "$this" in method

That's all, for now...
