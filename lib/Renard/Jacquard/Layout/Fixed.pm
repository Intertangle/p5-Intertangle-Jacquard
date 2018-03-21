use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Fixed;
# ABSTRACT: A fixed layout

use Renard::Incunabula::Common::Types qw(PositiveOrZeroNum);

use Moo;
use Tie::RefHash;
use Renard::Yarn::Graphene;
use Renard::Jacquard::Render::StateCollection;
use Renard::Taffeta::Transform::Affine2D;
use Renard::Taffeta::Transform::Affine2D::Translation;

=attr _data

Holds position data for each actor.

=cut
has _data => (
	is =>'ro',
	default => sub {
		my %hash;
		tie %hash, 'Tie::RefHash';
		\%hash;
	},
);

=method add_actor

Adds an actor a fixed C<( x, y )> position.

=cut
method add_actor( $actor, (PositiveOrZeroNum) :$x, (PositiveOrZeroNum) :$y ) {
	$self->_data->{ $actor } = { x => $x, y => $y };
}

=method update

Layout the actors.

=cut
method update( :$state ) {
	my @actors = keys %{ $self->_data };
	$self->_logger->trace( "Updating $self"  );

	my $output = Renard::Jacquard::Render::StateCollection->new;
	for my $actor (@actors) {
		my $input_state = defined $state ? $state : $self->input->get_state($actor);

		my $translate = Renard::Taffeta::Transform::Affine2D::Translation->new(
			translate => [
				$self->_data->{$actor}{x},
				$self->_data->{$actor}{y},
			],
		);
		my $state = Renard::Jacquard::Render::State->new(
			transform => $translate,
		);

		$output->set_state( $actor, $input_state->compose_premultiply($state) );
	}

	$output;
}

with qw(
	Renard::Jacquard::Layout::Role::WithInputStateCollection
	MooX::Role::Logger
);

1;
