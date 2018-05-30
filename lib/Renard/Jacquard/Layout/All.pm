use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::All;
# ABSTRACT: Assigns a single state to each child

use Moo;
use Renard::Jacquard::Render::State;

=attr state

The state to apply to all children.

=cut
has state => (
	is => 'ro',
	default => sub { Renard::Jacquard::Render::State->new },
);

=method update

Update layout.

=cut
method update( :$state ) {
	my @actors = @{ $self->_actors };

	my $state = defined $state ? $state : $self->state;
	my $output = Renard::Jacquard::Render::StateCollection->new;
	for my $actor (@actors) {
		$output->set_state( $actor, $state );
	}

	$output;
}

with qw(
	Renard::Jacquard::Layout::Role::AddActorNoOptions
);

1;
