package Coolinar::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

Coolinar::Controller::Root - Root Controller for Coolinar

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    #
    # TODO: Figure out how to do move this forwarding to config config out of the code code
    #
    $c->res->redirect( $c->uri_for( $c->controller('recipes')->action_for('list'), [ 0 ] ) );
}

=head2 auto

 Check for suer valiity before login

=cut
sub auto :Private {
    my ($self, $c) = @_;


    # Allow to use login page
    if ( $c->action eq $c->controller('Login')->action_for('index') ) {
	return 1;
    }

    # Check if user registered
    if (!$c->user_exists) {
	$c->log->info("** Attempt to access protected pages without authorization, forwarding to login");
	$c->response->redirect( $c->uri_for('/login') );

	return 0;
    }

    # pass the gate
    return 1;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
