use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Affine2D;
# ABSTRACT: Applies an affine 2D transform to each child

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);

=attr transform

The C<Renard::Taffeta::Transform::Affine2D> transform to apply to each child.

=cut
has transform => (
	is => 'ro',
	isa => InstanceOf['Renard::Taffeta::Transform::Affine2D'],
	default => sub {
		Renard::Taffeta::Transform::Affine2D->new
	},
);

=method geometry_transform

  method geometry_transform( :$state )

Returns a new state that only applies the C<transform> for this layout and
stores it as the new geometry transform.

=cut
method geometry_transform( :$state ) {
	Renard::Jacquard::Render::State->new(
		geometry_transform => $state->transform->compose( $self->transform ),
	)
}


=method update

Update layout.

=cut
method update( :$state ) :ReturnType(InstanceOf['Renard::Jacquard::Render::StateCollection']) {
	my @actors = @{ $self->_actors };
	$self->_logger->trace( "Updating $self"  );

	my $output = Renard::Jacquard::Render::StateCollection->new;
	for my $actor (@actors) {
		my $input_state = defined $state ? $state : $self->input->get_state($actor);
		$output->set_state( $actor,
			$input_state->compose(
				$self->geometry_transform( state => $input_state )
			)
		);
	}

	$output;
}

with qw(
	Renard::Jacquard::Layout::Role::GeometryTransformable
	Renard::Jacquard::Layout::Role::WithInputStateCollection
	Renard::Jacquard::Layout::Role::AddActorNoOptions
	MooX::Role::Logger
);

1;
