use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Taffeta::Graphics;
# ABSTRACT: Taffeta graphics actor

use Moo;

extends qw(Renard::Jacquard::Actor);

use Renard::Jacquard::Content::Null;

=attr content

The content for the actor.

=cut
has content => (
	is => 'ro',
	default => sub { Renard::Jacquard::Content::Null->new },
);

=method bounds

  method bounds( $state )

Retrieves the bounds of the actor via the content.

=cut
method bounds( $state ) {
	return $self->content->bounds( $state );
}

with qw(Renard::Jacquard::Actor::Role::DataPrinter);
method _data_printer_internal() { $self->content }

1;
