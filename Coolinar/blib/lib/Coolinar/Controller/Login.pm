package Coolinar::Controller::Login;


use utf8;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Coolinar::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index
TODO: Remove this section
=cut

# sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#
#    $c->response->body('Matched Coolinar::Controller::Login in Login.');
#}


=head2 index

Try to login

=cut
sub index :Path :Args(0) {
    my ($self, $c) = @_;

    my $username = $c->req->params->{username};
    my $password = $c->req->params->{password};

#
#    TODO: Remove following section after testing!
#
#    $c->log->debug( "** User cred $username $password" ) if ( $username && $password );
#    my $dummy = $c->user_exists;
#    $c->log->debug( "** user exists: [$dummy], " . ($c->user_exists() ? 'yes' : 'no') );
#    $c->log->debug( "** user exists: " . $c->user() );
#

    if( $username && $password ) {
	# Try to login
      	if ( $c->authenticate({ name => $username,
				pass => $password,
			      }) ) {
	  $c->log->debug( "** Lending confirmed: $username $password" );
	    $c->res->redirect( $c->uri_for(
				    $c->controller('Recipes')->action_for('list'), [0] ) );
	    return;
	} else {
	  $c->log->debug( "** Failed to pass $username $password" );
	    # failed to login, set the error message
	    $c->stash(error_msg => 'Не тот пользователь, али пароль кривой' );
	}
    } else {

	  unless ($c->user_exists) {
	    if ($username || $password) {
	      $c->stash(error_msg => 'Как-то криво задан пароль или имя пользователя' )
	    }
	  }
    }


    $c->response->header('Cache-Control' => 'no-cache');

    # If we are here, we still need to login
    return $c->stash( template => 'login.tt2' );
}

=head2 in

Try to logout

=cut
sub out :Path('/logout') :Args(0) {
    my ($self, $c) = @_;

    $c->logout;

    $c->res->redirect( $c->uri_for('/') );
}



=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
