use utf8;
package Coolinar::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Coolinar::Schema::Result::User

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 pass

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 r_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 1

=head2 when_created

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 when_updated

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "pass",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "r_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 1 },
  "when_created",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "when_updated",
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

=head2 comments

Type: has_many

Related object: L<Coolinar::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Coolinar::Schema::Result::Comment",
  { "foreign.u_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 r

Type: belongs_to

Related object: L<Coolinar::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "r",
  "Coolinar::Schema::Result::Role",
  { id => "r_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 recipe_authors

Type: has_many

Related object: L<Coolinar::Schema::Result::RecipeAuthor>

=cut

__PACKAGE__->has_many(
  "recipe_authors",
  "Coolinar::Schema::Result::RecipeAuthor",
  { "foreign.u_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-16 22:56:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sLmMCQjLCQi92/WUoHUqVg

#
# Password field encoding as it described in catalyst tutorial
#
__PACKAGE__->add_columns(
    'pass' => {
	passphrase       => 'rfc2307',
	passphrase_class => 'SaltedDigest',
	passphrase_args  => {
	    algorithm => 'SHA-1',
	    salt_random => 20.
	},
		passphrase_check_method => 'check_password',
    },
    );


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
