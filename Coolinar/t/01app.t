#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Coolinar';

ok( request('/'      )->is_redirect, 'Request should succeed' );
ok( request('/login' )->is_success,  'Request should succeed' );

done_testing();
