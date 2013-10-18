use utf8;
package Coolinar::Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Coolinar::Schema::Result::Comment

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

=head1 TABLE: C<comments>

=cut

__PACKAGE__->table("comments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 u_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 1

=head2 r_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 1

=head2 rate

  data_type: 'int'
  is_nullable: 1

=head2 post

  data_type: 'text'
  is_nullable: 1

=head2 when_posted

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "u_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 1 },
  "r_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 1 },
  "rate",
  { data_type => "int", is_nullable => 1 },
  "post",
  { data_type => "text", is_nullable => 1 },
  "when_posted",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0RPjVWPGHAHfKQ11XYx4QA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
