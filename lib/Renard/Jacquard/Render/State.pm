use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Render::State;
# ABSTRACT: A state that can be used for rendering content

use Moo;

use Renard::Yarn::Graphene;
use Renard::Incunabula::Common::Types qw(InstanceOf);

use Renard::Taffeta::Transform::Affine2D;

=method transform

A transform for the current state.

=cut
has transform => (
	is => 'ro',
	default => sub {
		Renard::Taffeta::Transform::Affine2D->new;
	}
);

=attr bounds

Type of bounds for the current state.

=cut
has bounds => (
	is => 'ro',
	isa => ( InstanceOf['Renard::Jacquard::Bounds::Unlimited'] | InstanceOf['Renard::Jacquard::Bounds::Limited'] ),
);

=attr color_transfer_function

To be implemented.

=cut
has color_transfer_function => (
	is => 'ro',
);

=method compose

Compose with another state.

=cut
method compose( $state ) {
	Renard::Jacquard::Render::State->new(
		transform => ( $self->transform->compose( $state->transform ) ),
	);
}

=method compose_premultiply

Compose with another state (premultiply).

=cut
method compose_premultiply( $state ) {
	Renard::Jacquard::Render::State->new(
		transform => ( $self->transform->compose_premultiply( $state->transform ) ),
	);
}

=method actor_coordinates_to_world_coordinates

This needs to be tested.

=cut
method actor_coordinates_to_world_coordinates( $position ) {
	my $world_vec = ($self->transform->matrix * $position)->to_vec2->add(
		$self->origin_vector
	);

	my $world_pos = Renard::Yarn::Graphene::Position->new(
		x => $world_vec->x,
		y => $world_vec->y,
	);
}

1;
