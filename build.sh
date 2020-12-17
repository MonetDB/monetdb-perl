#!/bin/bash

set -e -x

for i in DBD MonetDB-CLI/MonetDB MonetDB-CLI-MapiPP/MonetDB/CLI
do
	(
		cd $i
		perl Makefile.PL
		make
	)
done
