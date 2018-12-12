use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Role::Tree::TreeDAGNode::WithChildren;
# ABSTRACT: A role for actors with child actors

use Moo::Role;
use Renard::Jacquard::Types qw(Actor);

requires '_tree_dag_node';

=method add_child

Add a child actor.

=cut
method add_child( (Actor) $actor, %options  ) {
	$self->_tree_dag_node->add_daughter(
		$actor->_tree_dag_node
	);
}

=method number_of_children

Number of children for this actor.

=cut
method number_of_children() {
	scalar $self->_tree_dag_node->daughters;
}

=method children

Returns a C<ArrayRef> of the children of this actor.

=cut
method children( $children = undef ) {
	if( defined $children ) {
		$self->_tree_dag_node->clear_daughters;
		$self->_tree_dag_node->add_daughters(
			map { $_->_tree_dag_node } @$children
		);
	} else {
		return [ map { $_->attributes->{actor} } $self->_tree_dag_node->daughters ];
	}
}

after BUILD => method( $args ) {
	$self->children( $args->{children} ) if exists $args->{children};
};

1;
