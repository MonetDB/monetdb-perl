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

if (defined $ENV{DBI_DSN}) {
  plan tests => 9;
} else {
  plan skip_all => 'Cannot test without DB info';
}

my $dbh = DBI->connect or die "Connect failed: $DBI::errstr\n";
ok ( defined $dbh, 'Connection');

my $do_execute = 0;

sub process
{
	my $query = shift;
	my $sth = $dbh->prepare($query);

	my $expected = $sth->{NUM_OF_PARAMS};
	my @params = @_;
	my $nparams = @params;
	if ($nparams != $expected) {
		print "# expected $expected parameters, got $nparams\n";
		return undef;
	}

	return 1 unless $do_execute;

	print("# EXECUTE $query");
	print("# PARMS ", join('|', @params)) if @params;
	$sth->execute(@params);
	my @row;
	while (@row = $sth->fetchrow_array()) {
		print("# ROW ", join(' | ', @row), '\n');
	}

	return 1;
}


ok( process("SELECT 42"), 'no placeholders');

ok( process("SELECT ?", 42), 'one placeholder');

ok( process("-- '?\nSELECT 42"), 'not a real placeholder, is in a comment');

ok( process("-- '?\nSELECT ?", 42), 'commented placeholder and real placeholder');

ok( process("SELECT 42 -- ?"), 'commented placeholder at end');

ok( process("SELECT 42 --?\nWHERE TRUE"), 'commented placeholder, then more query');

ok( process("SELECT R'\\' ?", 'foo'), 'sdf');

ok( process("SELECT '\\' ?'"), 'not fooled by the backslash escape');
