use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::All;
# ABSTRACT: Assigns a single state to each child

use Moo;
use Renard::Jacquard::Render::State;

has state => (
	is => 'ro',
	default => sub { Renard::Jacquard::Render::State->new },
);

method update() {
	my @actors = @{ $self->_actors };

	my $output = Renard::Jacquard::Render::StateCollection->new;
	for my $actor (@actors) {
		$output->set_state( $actor, $self->state );
	}

	$output;
}

with qw(
	Renard::Jacquard::Layout::Role::WithInputStateCollection
	Renard::Jacquard::Layout::Role::AddActorNoOptions
);

1;
