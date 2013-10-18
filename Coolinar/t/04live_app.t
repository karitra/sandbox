#!/usr/bin/env perl

use utf8;

use strict;
use warnings;
use Test::More;

no warnings 'utf8';

# TODO: take from some config or so?
my $PORT    = 3000;
my $CLIENTS = 4;

my $def_user = 'guest';
my $def_pwd  = 'guest';


BEGIN { use_ok('Test::WWW::Mechanize::Catalyst' => 'Coolinar') }

my @ua;

push( @ua, Test::WWW::Mechanize::Catalyst->new()) for (1..$CLIENTS);

$ua[1]->allow_external();

$_->get_ok( "http://localhost:$PORT",        "Check redirect of base URL" ) for (@ua[0..1]);
$_->get_ok( "http://localhost:$PORT/list",   "Check redirect of base URL" ) for (@ua);
$_->get_ok( "http://localhost:$PORT/list/0", "Check redirect of base URL" ) for (@ua[1..$CLIENTS - 1]);

$_->content_contains('Пароль') for (@ua);

# make an url encoded attempt to login
$ua[0]->get_ok("http://localhost:$PORT/login?username=$def_user&password=$def_pwd", "Login '$def_user'");

# make form msubmit
$ua[1]->submit_form( fields => {
				username => 'guest1',
				password => 'guest1',
			       });

#
# Try to login again
#
$_->get_ok('/login')            for (@ua[0..1]);
$_->content_contains('Пароль')  for (@ua[0..1]);
$_->content_contains('Опа!')    for (@ua[0..1]);

$ua[0]->get_ok("http://localhost:$PORT/list/10");
$ua[0]->get_ok("http://localhost:$PORT/list");
$ua[0]->follow_link_ok({ text => 'Выход'});

#
# Logout for all
#
$_->get_ok( "http://localhost:$PORT/logout") for (@ua);
$_->get_ok( "http://localhost:$PORT/image" ) for (@ua[1..2]);
$_->content_lacks('Опа!')    for (@ua);


#
# Relogin
#
$ua[1]->get_ok("http://localhost:$PORT/login?username=$def_user&password=$def_pwd", "Login '$def_user'");
$ua[1]->get_ok("http://localhost:$PORT/image/10");
$ua[1]->get_ok("http://localhost:$PORT/list");

$ua[1]->get_ok("http://localhost:$PORT/list/10");

#my @dellinks = $ua[1]->find_all_links( text => 'Редактировать');
#$ua[1]->get_ok( $dellinks[$#dellinks]->url, 'Delete last recipe on page');

#
# TODO: add recipe test
#
$ua[1]->content_contains('alt="Food image"');
$ua[1]->submit_form( form_number => 1 );
$ua[1]->content_like(qr/Рецепт № \d+ удален/, "Deleted recipe #" );


done_testing;


