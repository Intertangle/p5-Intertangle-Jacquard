use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor;
# ABSTRACT: Base class for scene graph objects

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Jacquard::Types qw(Actor);
use Renard::Yarn::Types qw(Size);
use Tree::DAG_Node;

use Renard::Jacquard::Content::Null;

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

=attr content

The content for the actor.

=cut
has content => (
	is => 'ro',
	default => sub { Renard::Jacquard::Content::Null->new },
);

=method bounds

  method bounds( $state )

Retrieves the bounds of the actor via the content.

=cut
method bounds( $state ) {
	$self->content->bounds( $state );
}

=method add_child

Add a child actor.

=cut
method add_child( (Actor) $actor, %options  ) {
	$self->_tree_dag_node->add_daughter(
		$actor->_tree_dag_node
	);
	if( $self->has_layout ) {
		$self->layout->add_actor( $actor,
			exists $options{layout} ? %{ $options{layout} } : ()
		);
	}
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
method children() {
	[ map { $_->attributes->{actor} } $self->_tree_dag_node->daughters ];
}

=method parent

Returns the parent of this actor.

=cut
method parent() {
	return $self->_tree_dag_node->mother;
}

1;
