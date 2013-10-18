package Coolinar::Controller::Recipes;

use Coolinar::Form::Recipe;

use utf8;

use Moose;
use namespace::autoclean;
use POSIX qw/ceil/;



BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Coolinar::Controller::Recipes - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 

Some Moose config, not sure we need it!

=cut

#has 'form' => ( isa  => 'Coolinar::Form::Recipe', is => 'rw',
#		lazy => 1, 
#		default => sub { Coolinar::Form::Recipe->new } );


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Coolinar::Controller::Recipes in Recipes.');
}

=head2 pager

Store page offest for future usage

=cut

sub pager : Chained('/') : CaptureArgs(1) {
    my ($self, $c, $page) = @_;

    $c->stash(pg => $page);
}

=head2 create

Create a new recipe

=cut
sub create :Chained('pager') :PathPart('create') :Args(0) {
    my ($self, $c) = @_;

    my $recipe = $c->model('DB::Recipe')->new_result({});

    $c->stash->{create} = 1;

    return $self->form($c, $recipe);
}

=head2 edit

Edit recipe record

=cut
sub edit :Chained('object') :PathPart('edit') {
    my ($self, $c) = @_;

    $c->stash->{edit} = 1;

    return $self->form($c, $c->stash->{object} );
}

=head2 form

 Process recipe form

=cut
sub form {
    my ($self, $c, $recipe) = @_;
    
    my $form = Coolinar::Form::Recipe->new;

    $c->stash(
	wrapper  => 'form_wrapper.tt2',
	template => 'recipes/form.tt2',
	form     => $form );

    $form->process( item => $recipe, params => $c->req->params );

    return unless $form->validated;

    $c->res->redirect( $c->uri_for( $self->action_for('list'), 
				    [ $c->stash->{create} ? 0 : $c->stash->{pg} ] ) );
}

=head2 object

Get recipe object by provided id and store it in template stash

=cut

sub object :Chained('pager') :PathPart('id') :CaptureArgs(1) {
    # id - primary key of recipe
    my ( $self, $c, $id) = @_;

    $c->stash( object => $c->model('DB::Recipe')->find($id)  );

    $c->detach('/error_401') if ! $c->stash->{object};

    $c->log->debug("** Inside object with id => $id");
}

=head2 delete

Delete a recipe

=cut          

sub delete :Chained('object') :Args(0) {
    my ( $self, $c) = @_;

    $c->stash->{object}->delete;
    $c->stash( status_msg => 'Рецепт удален' );

    #
    # Hm, forward seems to not work. Why?
    #
    # $c->forward( 'list', $c->stash->{pg} );
    # 
    # $c->visit( 'list', [ $c->stash->{pg} ] );
    #
    $c->response->redirect( $c->uri_for( $self->action_for('list'), [ $c->stash->{pg} ] ) );

    #
    # FIXME?: should we really use detach here?
    # 
    $c->detach();

    $c->log->debug("** Delete complete, trying to go to page num: " . $c->stash->{pg} );
}

sub list :Path('/list') : Args(1) {
    my ( $self, $c, $page_num ) = @_;

    $page_num = 0 if ! defined  $page_num;

    # TODO: move to app (user in reall app) config
    my $per_page  = 8;
    my $pg_in_bar = 6;

    $c->detach('/error_401') if $page_num < 0;
    #die "Error1: page_num is less then or equal to zero" if $page_num <= 0;

    my $res = $c->model('DB::Recipe')->search( 
	undef, 
	{ page     => $page_num + 1, # page numbers are 1 based
	  rows     => $per_page,
	  order_by => { -desc => 'when_created' },
	});

    my $total_entries = $res->pager->total_entries;

    $c->stash( templale      => 'recipes/list.tt2', 
	       recipes       => [ $res->all() ],
	       total_entries => $total_entries,
	       total_pages   => $per_page == 0 ? 0 : ceil($total_entries / $per_page),
	       page_num      => $page_num,
	       per_page      => $per_page,
	       pg_in_bar     => $pg_in_bar );

    $c->log->debug("** Page num is $page_num");
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
