use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor;
# ABSTRACT: Base class for scene graph objects

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Jacquard::Types qw(Actor);
use Tree::DAG_Node;

=attr _tree_dag_node

Use delegation to C<Tree::DAG_Node> to build scene graph.

=cut
has _tree_dag_node => (
	is => 'ro',
	default => method() {
		Tree::DAG_Node->new({ attributes => { actor => $self } })
	},
	handles => {
		#parent => 'mother',
		#add_child => 'add_daughter',
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

with qw(MooX::Role::Logger);

1;
