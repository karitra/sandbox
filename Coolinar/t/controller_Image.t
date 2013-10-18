use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Coolinar';
use Coolinar::Controller::Image;

# ok( request('/login')->is_success, 'Request should succeed' );
ok( request('/image')->is_redirect, 'Request should succeed' );
done_testing();
