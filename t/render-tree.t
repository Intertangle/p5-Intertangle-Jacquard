#!/usr/bin/env perl

use Test::Most tests => 1;
use Renard::Incunabula::Common::Setup;

use lib 't/lib';

package GraphicsState {
	use Moo;
	use Renard::Incunabula::Common::Setup;

	use Renard::Yarn::Graphene;
	use Renard::Incunabula::Common::Types qw(InstanceOf);

	has transform => (
		is => 'ro',
		default => sub {
			Transform::Linear->new;
		}
	);

	has origin_vector => (
		is => 'ro',
		default => sub {
			Renard::Yarn::Graphene::Vec2->new( x => 0 , y => 0 );
		},
	);


	method push_node( $node, $position ) :ReturnType(InstanceOf['GraphicsState']) {
		my $transform = $self->transform->push_transform( $node->transform );
		GraphicsState->new(
			transform => $transform,
			origin_vector => $self->origin_vector->add(
				$position->to_vec2
			),
		);
	}

	method actor_coordinates_to_world_coordinates( $position ) {
		my $world_vec = ($self->transform->matrix * $position)->to_vec2->add(
			$self->origin_vector
		);

		my $world_pos = Renard::Yarn::Graphene::Position->new(
			x => $world_vec->x,
			y => $world_vec->y,
		);
	}
}

package Transform::Linear {

	method push_transform( $transform ) z
		Transform::Linear->new( matrix => ($self->matrix x $transform->matrix) );
	}
}

fun get_render_tree(
	:$root,
	:$state = GraphicsState->new,
	:$position = Renard::Yarn::Graphene::Point->new( x => 0 , y => 0 ) ) {

	use Carp::Always;
	my $tree = Tree::DAG_Node->new;
	my $new_state = $state->push_node( $root, $position );

	if( ref $root->content ne 'Renard::Jacquard::Content::Null' ) {
		my $taffeta = $root->content->as_taffeta(
			$new_state,
			$position,
		);

		$tree->attributes({
			render => $taffeta,
		});
	} else {
		my $positions = $root->layout->update( $new_state );

		my $children = $root->children;
		for my $child (@$children) {
			$tree->add_daughter(
				get_render_tree(
					root     => $child,
					state    => $new_state,
					position => $positions->{ $child },
				)
			);
		}
	}

	$tree;
}

use Renard::Jacquard::Content::Rectangle;


subtest "Build render tree" => sub {
	use Renard::Jacquard::Layout::AutofillGrid;
	use Renard::Taffeta::Style::Fill;
	use Renard::Jacquard::Actor;
	use Renard::Taffeta::Color::Named;

	# 1. get all the positions of the actors
	# 2. apply a transform to the root node (scaling)

	my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
		rows    => 2,
		columns => 3,
		intergrid_space => 10,
	);
	my $root = Renard::Jacquard::Actor->new( layout => $grid );

	my $matrix = Renard::Yarn::Graphene::Matrix->new;
	$matrix->init_scale( 5, 5, 1);
	my $transform = Transform::Linear->new( matrix => $matrix );
	$root->transform( $transform );

	my $actor_info = [
		[ 10, 10, 'red'     ],
		[  5, 10, 'green'   ],
		[ 10, 10, 'blue'    ],
		[ 10, 10, 'yellow'  ],
		[ 10, 10, 'magenta' ],
		[ 10, 20, 'cyan'    ],
	];

	for my $actor_param (@$actor_info) {
		my $actor = Renard::Jacquard::Actor->new(
			content => Renard::Jacquard::Content::Rectangle->new(
				width   => $actor_param->[0],
				height  => $actor_param->[1],
				fill    => Renard::Taffeta::Style::Fill->new(
					color => Renard::Taffeta::Color::Named->new( name => $actor_param->[2] ),
				),
			),
		);

		$root->add_child( $actor );
	}

	my $render_tree = get_render_tree( root => $root );
	use DDP; p $render_tree;

	use SVG;
	my $svg = SVG->new;
	$render_tree->walk_down({
		callback => fun( $node ) {

			if( exists $node->attributes->{render} ) {
				$node->attributes->{render}->render_svg( $svg );
			}

			return 1;
		},
	});

	path('render-tree.svg')->spew_utf8($svg->xmlify);

	#use DDP; p $root->transform->matrix;
	#use DDP; p $root, class => { expand => 'all' };
	pass;
};

done_testing;
