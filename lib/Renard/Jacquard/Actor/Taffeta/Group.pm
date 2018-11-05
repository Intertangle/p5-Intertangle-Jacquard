use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Taffeta::Group;
# ABSTRACT: An actor for grouping Taffeta actors

use Moo;

extends qw(Renard::Jacquard::Actor);

with qw(Renard::Jacquard::Actor::Role::WithChildren);

=attr layout

The layout to use for the children actors.

Predicate: C<has_layout>

=method has_layout

Predicate for C<layout> attribute.

=cut
has layout => (
	is => 'ro',
	predicate => 1,
);

=method bounds

  method bounds( $state )

Retrieves the bounds of the actor via the content.

=cut
method bounds( $state ) {
	my $states = $self->layout->update( state => $state );

	my @bounds = map { $_->bounds( $states->get_state($_) ) } @{ $self->children };
	my $rect = shift @bounds;
	while( @bounds ) {
		$rect = $rect->union( shift @bounds );
	}
	return $rect;
}

after add_child => method( $actor, %options ) {
	if( $self->has_layout ) {
		$self->layout->add_actor( $actor,
			exists $options{layout} ? %{ $options{layout} } : ()
		);
	}
};

1;
