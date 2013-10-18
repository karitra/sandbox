use utf8;
package Coolinar::Schema::Result::RecipeAuthor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Coolinar::Schema::Result::RecipeAuthor

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<recipe_author>

=cut

__PACKAGE__->table("recipe_author");

=head1 ACCESSORS

=head2 r_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 1

=head2 u_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "r_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 1 },
  "u_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 1 },
);

=head1 RELATIONS

=head2 r

Type: belongs_to

Related object: L<Coolinar::Schema::Result::Recipe>

=cut

__PACKAGE__->belongs_to(
  "r",
  "Coolinar::Schema::Result::Recipe",
  { id => "r_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 u

Type: belongs_to

Related object: L<Coolinar::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "u",
  "Coolinar::Schema::Result::User",
  { id => "u_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-16 22:56:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jw16uORwiVU0GsV3k6f19g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
