#!/bin/env perl

use strict;
use warnings;

use Coolinar::Schema;

my $schema = Coolinar::Schema->connect('dbi:SQLite:coolinar.db');

my @users = $schema->resultset('User')->all;

for my $u (@users) {
    print $u->pass($u->name);
    $u->update;
}
