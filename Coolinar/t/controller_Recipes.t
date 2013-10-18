use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Coolinar';
use Coolinar::Controller::Recipes;

ok( request('/list/0')->is_redirect, 'Request should succeed' );
done_testing();
