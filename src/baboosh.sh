#!/bin/bash
#author Patrice FERLET
#Licence BSD

#set 2 options, the first 'set -u' write error
#on not declared variables, the second 'shopt' is used
#to let script uses "alias" internaly
set -u
shopt -s expand_aliases

#this function declare the property to 
#return (with echo) a value
#@scope private
_meta_class_set_var(){
    local obj=$1
    local varname=$2
    shift 2

    local value="$@"

    alias ${obj}.${varname}="echo \"$value\""

}

#"new" create an object based on class
#usage: new ClassType ObjName [args...]
#@scope public
new(){
    local class=$1
    local obj=$2
    shift 2

    local _i=0
    local _type=""
    local _val=""

    local _argv=""
    local _argc=${#@}
    local _init_args=""

    #keep a nice arguments list to send to constructor
    #remember that args begin at 1
    _i=1
    while [[ $_i < $((_argc+1)) ]]; do
        _init_args=$_init_args" \"\$"$_i\"
        _i=$((_i+1))
    done

    _i=0

    #get class elements
    meta=$( eval echo \${$class[@]}  )

    #foreach element in declaration list, append it in
    #alias list
    for data in $meta
    do
        #flip flop with modulo
        if [ $((_i%2)) -eq 0 ]; then
            _type="$data"
        else
            case $_type in
                function)
                    #link function to Class method sending current object
                    #as first argument
                    alias $obj.$data="$class::$data $obj"
                    ;;
                var)
                    #set aliases to set and get vars
                    alias $obj.$data='eval "echo $'${obj}__${data}'"'
                    alias $obj.set_$data="_meta_class_set_var $obj $data"
                    ;;
                extends)
                    eval new $data $obj
                     
                    ;;
                *)
                    echo "$_type undefined"
                    exit 1
                    ;;
            esac
        fi
        _i=$((_i+1))
    done
    
    if [[ "$(type -t $class::__init__)" == "function" ]]; then
        #constructor found
        alias $obj.__init__="$class::__init__ $obj"
         #call constructor with args redecorated
        eval $obj.__init__ $_init_args
    fi
}
