use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Coolinar';
use Coolinar::Controller::Login;

ok( request('/login'  )->is_success,  'Request should succeed' );
ok( request('/logout' )->is_redirect, 'Request should succeed' );
done_testing();
