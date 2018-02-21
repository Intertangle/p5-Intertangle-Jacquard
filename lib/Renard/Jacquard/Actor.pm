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

has layout => (
	is => 'ro',
);

has bounds => (
	is => 'ro',
);

method add_child( (Actor) $actor, %options  ) {
	$self->_tree_dag_node->add_daughter(
		$actor->_tree_dag_node
	);
	if( exists $options{layout} && defined $options{layout} ) {
		$self->layout->add_actor( $actor, %{ $options{layout} } );
	}
}

method number_of_children() {
	scalar $self->_tree_dag_node->daughters;
}

method children() {
	[ map { $_->attributes->{actor} } $self->_tree_dag_node->daughters ];
}

method parent() {
	return $self->_tree_dag_node->mother;
}

1;
