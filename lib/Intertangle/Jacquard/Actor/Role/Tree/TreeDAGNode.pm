use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Actor::Role::Tree::TreeDAGNode;
# ABSTRACT: Store in Tree::DAG_Node

use Moo::Role;

use Renard::Incunabula::Common::Types qw(InstanceOf);
use Tree::DAG_Node;

=attr _tree_dag_node

Use delegation to C<Tree::DAG_Node> to build scene graph.

=cut
has _tree_dag_node => (
	is => 'ro',
	isa => InstanceOf['Tree::DAG_Node'],
	default => method() {
		Tree::DAG_Node->new({ attributes => { actor => $self } })
	},
);


=method parent

Returns the parent of this actor.

=cut
method parent() {
	my $parent_dag = $self->_tree_dag_node->mother;
	return defined $parent_dag
		? $parent_dag->attributes->{actor}
		: undef;
}

1;
