#!/bin/bash

set -e -x

export DBI_DSN=dbi:monetdb:database=demo

export PERL5LIB=$PWD/MonetDB-CLI-MapiPP:$PWD/MonetDB-CLI:$PWD

for i in DBD MonetDB-CLI/MonetDB MonetDB-CLI-MapiPP/MonetDB/CLI
do
	(
		cd $i
		perl Makefile.PL
		make
	)
done

make -C DBD test
:
make -C MonetDB-CLI/MonetDB test
:
make -C MonetDB-CLI-MapiPP/MonetDB/CLI test
:
