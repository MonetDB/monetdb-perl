#!/bin/bash

set -e -x

export PERL5LIB=$PWD/MonetDB-CLI-MapiPP:$PWD/MonetDB-CLI:$PWD

for i in DBD MonetDB-CLI/MonetDB MonetDB-CLI-MapiPP/MonetDB/CLI
do
	(
		cd $i
		perl Makefile.PL
		make
	)
done
