#!perl -I./t

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 1997 - July 2008 CWI, August 2008 - 2020 MonetDB B.V.

$| = 1;

use strict;
use warnings;
use DBI();
use DBD_TEST();

use Test::More;

if (defined $ENV{DBI_DSN}) {
  plan tests => 5;
} else {
  plan skip_all => 'Cannot test without DB info';
}

my $dbh = DBI->connect or die "Connect failed: $DBI::errstr\n";
pass('Database connection created');

# fetch 1000 of the 5000 rows, see Bug 2889
my $query = qq{
	SELECT * FROM sys.generate_series(0,5000);
};
my $sth = $dbh->prepare($query);
$sth->execute;
my $r = $sth->fetchall_arrayref(undef, 1000);
my $count = scalar(@{$r}); # don't say perl isn't weird
ok($count == 1000, 'got 1000 rows as requested');

# fetch a lot of rows and see we don't get disconnected halfway, see Bug 2897
$query = qq{
	SELECT * FROM tables, sys.generate_series(0,1000);
};
$sth = $dbh->prepare($query);
$sth->execute;
$r = $sth->fetchall_arrayref();
$count = scalar(@{$r});
ok($count % 1000 == 0, "got $count rows");

# fetch some data using fetchrow_array
# fetch a lot of rows and see we don't get disconnected halfway, see Bug 2897
$query = qq{
	SELECT value as i, value as j, value as k FROM sys.generate_series(0,100);
};
$sth = $dbh->prepare($query);
$sth->execute;
my $cells = 0;
while (my @row = $sth->fetchrow_array) {
	$cells += 1 + $#row;
}
is($cells, 300, 'fetch items using fetchrow_array');

ok( $dbh->disconnect,'Disconnect');
