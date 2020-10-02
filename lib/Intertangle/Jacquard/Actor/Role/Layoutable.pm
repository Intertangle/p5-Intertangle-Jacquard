use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Actor::Role::Layoutable;
# ABSTRACT: A role for actors that can layout their children

use Moo::Role;

with qw(Intertangle::Jacquard::Actor::Role::Tree::TreeDAGNode::WithChildren);

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

after add_child => method( $actor, %options ) {
	if( $self->has_layout ) {
		$self->layout->add_actor( $actor,
			exists $options{layout} ? %{ $options{layout} } : ()
		);
	}
};

1;
