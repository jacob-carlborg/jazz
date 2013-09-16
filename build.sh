#!/bin/sh

if [ -s "$HOME/.dvm/scripts/dvm" ] ; then
    . "$HOME/.dvm/scripts/dvm" ;
    dvm use 2.063.2
fi

rdmd --build-only -J. -debug -gc -ofbin/main -Imambo -L-ltango "$@" main.d