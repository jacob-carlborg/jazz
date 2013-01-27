#!/bin/sh

if [ -s "$HOME/.dvm/scripts/dvm" ] ; then
    . "$HOME/.dvm/scripts/dvm" ;
    dvm use 2.061
fi

rdmd --build-only -debug -gc -ofbin/jdc -Imambo -L-ltango "$@" main.d