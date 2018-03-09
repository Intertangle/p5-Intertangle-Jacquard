#!/usr/bin/env perl

use Test::Most tests => 1;
use Renard::Incunabula::Common::Setup;

use lib 't/lib';

fun get_render_tree(
	:$root,
	:$state = Renard::Jacquard::Render::State->new,
	) {

	use Carp::Always;
	my $tree = Tree::DAG_Node->new;

	if( ref $root->content ne 'Renard::Jacquard::Content::Null' ) {
		my $taffeta = $root->content->as_taffeta(
			$state,
		);

		$tree->attributes({
			render => $taffeta,
		});
	} else {
		my $states = $root->layout->update;
		my $children = $root->children;

		for my $child (@$children) {
			my $new_state = $states->get_state( $child );
			$tree->add_daughter(
				get_render_tree(
					root     => $child,
					state    => $new_state,
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
	use Renard::Jacquard::Layout::Affine2D;
	use Renard::Jacquard::Layout::All;
	use Renard::Jacquard::Layout::Composed;
	use Renard::Jacquard::Render::State;

	my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
		rows    => 2,
		columns => 3,
		intergrid_space => 10,
	);

	my $matrix = Renard::Yarn::Graphene::Matrix->new;
	$matrix->init_scale( 8, 5, 1);
	my $affine2d = Renard::Jacquard::Layout::Affine2D->new(
		transform => Renard::Taffeta::Transform::Affine2D->new(
			matrix => $matrix,
		)
	);

	my $composed = Renard::Jacquard::Layout::Composed->new(
		layouts => [
			Renard::Jacquard::Layout::All->new,
			$affine2d,
			$grid,
		],
	);

	my $root = Renard::Jacquard::Actor->new( layout => $composed );

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
	#use DDP; p $render_tree;

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
