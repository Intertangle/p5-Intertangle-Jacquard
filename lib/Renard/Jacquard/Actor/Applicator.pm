use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Applicator;
# ABSTRACT: An attribute applicator node

use Mu;

extends qw(Renard::Jacquard::Actor);

with qw(Renard::Jacquard::Actor::Role::Tree::TreeDAGNode::WithChildren);

has attribute_graph => (
	is => 'rw',
	required => 1,
);

has scene_graph => (
	is => 'rw',
	required => 1,
);

after BUILD => method() {
	$self->children(
		[ $self->attribute_graph, $self->scene_graph ]
	);
};

1;
