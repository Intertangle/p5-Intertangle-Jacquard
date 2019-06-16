use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Taffeta::Group;
# ABSTRACT: An actor for grouping Taffeta actors

use Moo;

extends qw(Renard::Jacquard::Actor);

with qw(Renard::Jacquard::Actor::Role::Layoutable);

=method bounds

  method bounds( $state )

Retrieves the bounds of the actor via the content.

=cut
method bounds( $state ) {
	my $states = $self->layout->update( state => $state );

	my @bounds = map { $states->get_state($_)->r_bounds($_) } @{ $self->children };
	my $rect = shift @bounds;
	while( @bounds ) {
		$rect = $rect->union( shift @bounds );
	}
	return $rect;
}

1;
