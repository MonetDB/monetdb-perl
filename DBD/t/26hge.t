#!perl -I./t

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 1997 - July 2008 CWI, August 2008 - 2019 MonetDB B.V.

$| = 1;

use strict;
use warnings;
use DBI();
use DBD_TEST();

use Test::More;

if ( !defined $ENV{DBI_DSN} ) {
  plan skip_all => 'Cannot test without DB info';
}


my $dbh = DBI->connect or die "Connect failed: $DBI::errstr\n";
$dbh->{RaiseError} = 1;
$dbh->{PrintError} = 0;

my $chk128 = $dbh->prepare("SELECT * FROM sys.types WHERE systemname = 'hge'");
$chk128->execute;
my $hgetypes = $chk128->fetchall_arrayref;
if (@{$hgetypes}) {
	plan tests => 11;
} else {
	plan skip_all => "no hge support";
}

ok($dbh->do('DROP TABLE IF EXISTS perl_dec38;'), 'DROP TABLE');
ok($dbh->do(qq{
	CREATE TABLE perl_dec38 (
		h HUGEINT,
		d38_0 DECIMAL(38,0),
		d38_19 DECIMAL(38,19),
		d38_38 DECIMAL(38,38)
	);}),
	'CREATE TABLE');
ok($dbh->do(qq{INSERT INTO perl_dec38 VALUES (
		12345678901234567899876543210987654321,
		12345678901234567899876543210987654321,
		1234567890123456789.9876543210987654321,
		.12345678901234567899876543210987654321
	);}),
	'INSERT');


my ($hge, $s0, $s19, $s38) = $dbh->selectrow_array(qq{
	SELECT
		h,
		CAST(d38_0 AS TEXT) AS s0,
		CAST(d38_19 AS TEXT) AS s19,
		CAST(d38_38 AS TEXT) AS s38
	FROM perl_dec38;});
is("$hge", '12345678901234567899876543210987654321', 'selectrow_array huge 12345678901234567899876543210987654321');
is("$s0", '12345678901234567899876543210987654321', 'selectrow_array dec 12345678901234567899876543210987654321');
is("$s19", '1234567890123456789.9876543210987654321', 'selectrow_array dec 1234567890123456789.9876543210987654321');
is("$s38", '0.12345678901234567899876543210987654321', 'selectrow_array dec 0.12345678901234567899876543210987654321');




my $rowref = $dbh->selectrow_arrayref(qq{
	SELECT
		h,
		CAST(d38_0 AS TEXT) AS s0,
		CAST(d38_19 AS TEXT) AS s19,
		CAST(d38_38 AS TEXT) AS s38
	FROM perl_dec38;});
is("$rowref->[0]", '12345678901234567899876543210987654321', 'selectrow_array huge 12345678901234567899876543210987654321');
is("$rowref->[1]", '12345678901234567899876543210987654321', 'selectrow_array dec 12345678901234567899876543210987654321');
is("$rowref->[2]", '1234567890123456789.9876543210987654321', 'selectrow_array dec 1234567890123456789.9876543210987654321');
is("$rowref->[3]", '0.12345678901234567899876543210987654321', 'selectrow_array dec 0.12345678901234567899876543210987654321');


