use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Graph::Render;
# ABSTRACT: A render graph

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Jacquard::Render::GenerateTree;

has graph => (
	is => 'ro',
	isa => InstanceOf['Tree::DAG_Node'],
	required => 1,
);


method to_svg() {
	my $gen = Renard::Jacquard::Render::GenerateTree->new;
	return $gen->render_tree_to_svg(
		$self->graph
	)
}

1;
