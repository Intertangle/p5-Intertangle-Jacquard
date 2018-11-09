use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Graph::Render;
# ABSTRACT: A render graph

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Yarn::Types qw(Point);
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

method hit_test_nodes( (Point->coercibles) $point ) {
	$point = Point->coerce($point);
	my @nodes = $self->_walk_hit_test( $self->graph, $point );
	@nodes;
}

method _walk_hit_test( $node, (Point) $point ) {
	my @nodes = ();
	my @daughters = $node->daughters;
	my $contains = $node->attributes->{bounds}->contains_point( $point );
	if( $contains ) {
		push @nodes, $node;
		for my $daughter (@daughters) {
			push @nodes, $self->_walk_hit_test( $daughter, $point );
		}
	}

	return @nodes;
};

1;
