#!perl -I./t

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 1997 - July 2008 CWI, August 2008 - 2019 MonetDB B.V.

$| = 1;

use strict;
use warnings;
use Data::Dumper;
use DBI();
use DBD_TEST();

use Test::More;

if (defined $ENV{DBI_DSN}) {
  plan tests => 19;
} else {
  plan skip_all => 'Cannot test without DB info';
}

pass('Simple prepare/execute/finish tests');

my $dbh = DBI->connect or die "Connect failed: $DBI::errstr\n";
pass('Database connection created');

my $tbl = $DBD_TEST::table_name;

{
  local ($dbh->{PrintError}, $dbh->{RaiseError}, $dbh->{Warn});
  $dbh->{PrintError} = 0; $dbh->{RaiseError} = 0; $dbh->{Warn} = 0;
  $dbh->do("DROP TABLE $tbl");
}

ok( $dbh->disconnect,'Disconnect');

$dbh = DBI->connect or die "Connect failed: $DBI::errstr\n";
pass('Database connection created');
{
  local $dbh->{PrintError} = 0;
  local $dbh->{RaiseError} = 1;
  ok( !eval{ $dbh->do("DROP TABLE $tbl") },"DROP TABLE $tbl");
  ok( $@ =~ /no such table/, "DROP TABLE failed for the right reason");
}
ok( $dbh->do("CREATE TABLE $tbl( chr char( 1 ) )"),"CREATE TABLE $tbl");

my $sth;
ok( $sth = $dbh->prepare("SELECT * FROM $tbl"),"SELECT * FROM $tbl");
ok( $sth->execute,'Execute');
ok( $sth->finish,'Finish');
ok( $sth = $dbh->prepare("SELECT * FROM $tbl"),"SELECT * FROM $tbl");
ok( $sth->finish,'Finish');
ok( $sth = $dbh->prepare("SELECT * FROM $tbl"),"SELECT * FROM $tbl");
ok( !( $sth = undef ),'Set sth to undefined');
#ok( $sth = $dbh->prepare("SELECT * FROM $tbl", { monetdb_ => ... } ),"SELECT * FROM $tbl ( monetdb_ => ... )");
#ok( $sth->execute,'Execute');
#ok( !( $sth = undef ),'Set sth to undefined');
ok( $dbh->do("DROP TABLE $tbl"),"DROP TABLE $tbl");

# Bug 3235
ok( $sth = $dbh->prepare("SELECT 0"), "SELECT 0");
ok( $sth->execute, 'Execute');
my $res = $sth->fetchall_arrayref;
$Data::Dumper::Terse = 1;        # don't output names where feasible
my $dumped = Dumper($res);
$dumped =~ s/\s+/ /gm;
ok( $res->[0]->[0] == 0, "yields $dumped");

ok( $dbh->disconnect,'Disconnect');
