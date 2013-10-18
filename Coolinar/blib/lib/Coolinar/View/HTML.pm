package Coolinar::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
    WRAPPER => 'wrapper.tt2',
    ENCODING => 'utf-8',
#    DEBUG => 'off',
);

=head1 NAME

Coolinar::View::HTML - TT View for Coolinar

=head1 DESCRIPTION

TT View for Coolinar.

=head1 SEE ALSO

L<Coolinar>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
