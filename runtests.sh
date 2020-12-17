#!/bin/bash

DBPATH="$PWD"/DB


set -e -x

# Start the mserver
rm -rf "$DBPATH"
mkdir "$DBPATH"
mserver5 --dbpath="$DBPATH/perltestdb" >"$DBPATH/mserver5.log" 2>&1 &
pid=$!
trap "kill -9 $pid 2>/dev/null" EXIT


# After a few seconds, check if it's still running
sleep 3
if ! kill -0 $pid 2>/dev/null; then
	echo "MSERVER STOPPED EARLY"
	cat "$DBPATH/mserver5.log"
	exit 1
fi

export DBI_DSN=dbi:monetdb:database=perltestdb
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
