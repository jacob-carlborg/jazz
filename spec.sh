#!/bin/sh

if [ -s "$HOME/.dvm/scripts/dvm" ] ; then
    . "$HOME/.dvm/scripts/dvm" ;
    dvm use 2.061
fi

function all_files () {
	find $1 -name '*.d' -exec echo -n '{} ' \;
}

jazz=`all_files jazz`
mambo=`all_files mambo/mambo`
dspec=`all_files mambo/dspec`
specs=`all_files spec`

dmd -I. -Imambo -L-ltango -unittest -ofspec_bin $jazz $mambo $dspec $specs

if [ "$?" = 0 ] ; then
  ./spec_bin
fi