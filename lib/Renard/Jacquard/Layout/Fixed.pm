package Renard::Jacquard::Layout::Fixed;
use Renard::Incunabula::Common::Setup;
# ABSTRACT: A fixed layout

use Renard::Incunabula::Common::Types qw(PositiveOrZeroNum);

use Moo;
use Tie::RefHash;
use Renard::Yarn::Graphene;

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

method add_actor( $actor, (PositiveOrZeroNum) :$x, (PositiveOrZeroNum) :$y ) {
	$self->_data->{ $actor } = { x => $x, y => $y };
}

method update() {
	my @actors = keys %{ $self->_data };
	my %actor_positions;
	tie %actor_positions, 'Tie::RefHash';


	for my $actor (@actors) {
		$actor_positions{ $actor } = Renard::Yarn::Graphene::Point->new(
			x => $self->_data->{$actor}{x},
			y => $self->_data->{$actor}{y},
		)
	}

	\%actor_positions;
}


1;
