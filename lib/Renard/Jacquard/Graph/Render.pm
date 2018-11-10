use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Graph::Render;
# ABSTRACT: A render graph

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Yarn::Types qw(Point);
use Renard::Jacquard::Render::GenerateTree;
use Renard::Taffeta::Transform::Affine2D::Translation;
use Renard::Jacquard::Render::State;

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

method render_to_cairo( (InstanceOf['Cairo::Context']) $cr, (InstanceOf['Renard::Jacquard::View::Taffeta']) $view ) {
	my $bounds = $view->viewport->identity_bounds;
	my $render_state =
		Renard::Jacquard::Render::State->new(
			coordinate_system_transform =>
				Renard::Taffeta::Transform::Affine2D::Translation->new(
					translate => [ - $bounds->origin->x, - $bounds->origin->y ],
				)
		);


	$cr->save;

	$self->_walk_cairo_render(
		$self->graph,
		$cr,
		$bounds,
		$render_state,
	);

	$cr->restore;
}

method _walk_cairo_render( $node, (InstanceOf['Cairo::Context']) $cr, $bounds, $render_state ) {
	my @daughters = $node->daughters;

	my $renderable = exists $node->attributes->{renderable};
	my ($in_bounds, $res) = $bounds->intersection($node->attributes->{bounds});
	if( $renderable && $in_bounds ) {
		#use DDP; p $node->attributes->{scene_graph}->content->page_number;

		my $state = $node->attributes->{state}->compose( $render_state );
		#my $state = $node->attributes->{state};

		my $el = $node->attributes->{scene_graph}->content->as_taffeta(
			state => $state,
		)->render_cairo( $cr );
		#my $el = $node->attributes->{render}->render_cairo( $cr );
	}
	for my $daughter (@daughters) {
		$self->_walk_cairo_render(
			$daughter,
			$cr,
			$bounds,
			$render_state,
		);
	}
};

1;
