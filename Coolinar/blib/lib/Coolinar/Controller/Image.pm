package Coolinar::Controller::Image;
use Moose;
use namespace::autoclean;

use Cwd;
use Fcntl qw/:flock/;
use constant DEFAULT_THUMB_KEY =>  'default_thumb';

# use Cwd;

BEGIN { extends 'Catalyst::Controller'; }

my $SEMAPHORE   = 'tumbnails.lock';
my $DUMMY_THUMB = 'root/assets/images/salty-snacks.jpg';

#
# TODO: take it from config!
#
use constant THUMB_CACHE_EXPIRE_SEC => 1200; # in seconds

=head1 NAME

Coolinar::Controller::Image - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Image retrival from cache or (if miss) from database

=cut

sub index :Path :Args(1) {
    my ( $self, $c, $id ) = @_;

    #my $thumb = $self->get_thumbnail($id);

    #
    # Check if recipe is in database
    #
    my $recipe = $c->model('DB::Recipe')->find( 
	$id, 
	{ 'columns' => ['id'] } );

    #
    # Try to get image
    # 
    my $thumb  = $self->get_thumbnail($c, $recipe->id);

#    $c->log->debug( "** Thumb is $thumb" );
 
 #   $c->response->body( "Matched Coolinar::Controller::Image in Image: id => $id" );
    
    $c->res->content_type('image/jpeg');
    $c->res->body( $thumb );
}

#
# Note 1: In real app images will be stored in database
# Note 2: Better to use some kind of treansaction here
#
# TODO: implement image update by user (clear or update the cache)
#
sub get_thumbnail {
    my ($self, $c, $id) = @_;

    $c->log->debug('** In get thumbnail: ' . $id );

    my $lock  = make_lock();

    my $cache = $c->cache;
    my $thumb = $cache->get( $id );

    #
    # If not in cache
    #
    unless ($thumb) {
	$c->log->debug('** Cache miss: ' . $id );
    
	#
	# 1. Try to get thumbnail from database
	#
	$thumb = $c->model('DB::Recipe')->find(
	    $id, 
	    { columns => [ qw/thumbnail/ ] },
	    )->thumbnail;

	unless ($thumb) {
	    $c->log->debug('** Not in model: ' . $id );
	    $c->log->debug('Workin dir is: ' . cwd() );
	    # it isn't in database, set default image as placeholed
	    $thumb = `cat $DUMMY_THUMB`;
	}

	# Update the cache
	$c->log->debug('** Updating the cache: ' . $id );
	$cache->set( $id, $thumb, THUMB_CACHE_EXPIRE_SEC );
    }

    make_unlock( $lock );
    return $thumb;
}

=head2 make_lock

 make_lock/unlock pair - Not best way of locking

=cut
sub make_lock {
    open my $lock, ">$SEMAPHORE";
    flock $lock, LOCK_EX;

    return $lock;
}

sub make_unlock {
    my $lock = shift;

    close $lock;
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
