use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Render::State;
# ABSTRACT: A state that can be used for rendering content

use Moo;

use Renard::Yarn::Graphene;
use Renard::Incunabula::Common::Types qw(InstanceOf);

use Renard::Taffeta::Transform::Affine2D;

has transform => (
	is => 'ro',
	default => sub {
		Renard::Taffeta::Transform::Affine2D->new;
	}
);

has bounds => (
	is => 'ro',
	isa => ( InstanceOf['Renard::Jacquard::Bounds::Unlimited'] | InstanceOf['Renard::Jacquard::Bounds::Limited'] ),
);

has color_transfer_function => (
	is => 'ro',
);

method compose( $state ) {
	Renard::Jacquard::Render::State->new(
		transform => ( $self->transform->compose( $state->transform ) ),
	);
}

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
