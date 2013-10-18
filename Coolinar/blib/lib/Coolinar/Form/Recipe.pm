package Coolinar::Form::Recipe;

use utf8;
use namespace::autoclean;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

# Note: not used as it vor bootstrap v2 and we are using >= v3
with qw/HTML::FormHandler::Widget::Theme::Bootstrap/;

sub build_messages {
    return { required => 'это поле надо бы заполнить' };
}

has '+item_class' => ( default => 'Recipes' );

has_field 'name'   => (	required   => 1,
			minlengtht => 3,
			maxlengtht => 64,
			label      => 'Название' );

has_field 'desc'   => ( type     => 'TextArea', 
			required => 1, 
			label    => 'Рецепт',
			row      => 10 );

has_field 'submit' => ( type => 'Submit', 
			value => 'Submit',
			label => 'Обновить' );

__PACKAGE__->meta->make_immutable;
1;
