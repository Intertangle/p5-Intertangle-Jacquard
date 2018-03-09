use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Render::StateCollection;
# ABSTRACT: A collection of actors to states

use Moo;
use Renard::Incunabula::Common::Types qw(HashRef);

use Tie::RefHash;

has _data => (
	is => 'ro',
	default => sub {
		my %actor_states;
		tie %actor_states, 'Tie::RefHash';

		\%actor_states;
	},
	isa => HashRef,
);

method set_state( $actor, $state ) {
	$self->_data->{ $actor } = $state;
}

method get_state( $actor ) {
	return $self->_data->{ $actor };
}

method number_of_actors() {
	keys %{ $self->_data };
}

1;
