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

#trapper function that call each destructor before to quit
_meta_class_delete_all(){
    local objects=$(alias -p | awk '/::__delete__/{ print $2}' | cut -f1 -d".")

    local exit_code=0

    for ob in $objects; do
        eval $ob.__delete__ || exit_code=$?
    done
    exit $exit_code
}

#trapper function that call each destructor before to quit
_meta_class_kill_all(){
    local objects=$(alias -p | awk '/::__kill__/{ print $2}' | cut -f1 -d".")

    local exit_code=0

    for ob in $objects; do
        eval $ob.__kill__ || exit_code=$?
    done
    exit $exit_code
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
                    alias $obj.parent='eval "echo '${data}'"'
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
    

    #append constructor
    if [[ "$(type -t $class::__init__)" == "function" ]]; then
        #constructor found
        alias $obj.__init__="$class::__init__ $obj"
        #call constructor with args redecorated
        eval $obj.__init__ $_init_args
    fi

    #append delete desctuctor
    if [[ "$(type -t $class::__delete__)" == "function" ]]; then
        alias $obj.__delete__="$class::__delete__ $obj"
    fi
    #append kill desctuctor
    if [[ "$(type -t $class::__kill__)" == "function" ]]; then
        alias $obj.__kill__="$class::__kill__ $obj"
    fi
}

trap _meta_class_kill_all INT TERM
trap _meta_class_delete_all EXIT
