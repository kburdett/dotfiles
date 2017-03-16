#! /usr/bin/env bash

dm-activate () {
    if [[ $(hash docker-machine 2>/dev/null) ]]; then
        echo docker-machine is not installed
        return 99
    fi

    if [[ -z $1 ]]; then
        echo Machine name is required
        return 99
    fi

    if [[ "$(docker-machine active)" == "$1" ]]; then
        echo $1 is already the active host
        return 0
    fi

    currentStatus="$(docker-machine status $1)"

    if [[ $? != 0 ]]; then
        return 1
    fi

    if [[ "$currentStatus" != 'Running' ]]; then
        docker-machine start $1
    fi

    echo Activating $1
    eval "$(docker-machine env $1)"
}

