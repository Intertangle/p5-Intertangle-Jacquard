#!/usr/bin/env perl

use Test::Most tests => 1;
use Test::Needs qw(SVG Data::Printer);

use Renard::Incunabula::Common::Setup;

use Renard::Jacquard::Content::Rectangle;
use Path::Tiny;


subtest "Build render tree" => sub {
	use Renard::Jacquard::Layout::AutofillGrid;
	use Renard::Taffeta::Style::Fill;
	use Renard::Jacquard::Actor;
	use Renard::Jacquard::Actor::Taffeta::Group;
	use Renard::Jacquard::Actor::Taffeta::Graphics;
	use Renard::Taffeta::Color::Named;
	use Renard::Jacquard::Layout::Affine2D;
	use Renard::Jacquard::Layout::All;
	use Renard::Jacquard::Layout::Composed;
	use Renard::Jacquard::Render::GenerateTree;

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

	my $root = Renard::Jacquard::Actor::Taffeta::Group->new( layout => $composed );

	my $actor_info = [
		[ 10, 10, 'red'     ],
		[  5, 10, 'green'   ],
		[ 10, 10, 'blue'    ],
		[ 10, 10, 'yellow'  ],
		[ 10, 10, 'magenta' ],
		[ 10, 20, 'cyan'    ],
	];

	for my $actor_param (@$actor_info) {
		my $actor = Renard::Jacquard::Actor::Taffeta::Graphics->new(
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

	my $render_tree = Renard::Jacquard::Render::GenerateTree
		->get_render_tree( root => $root );

	my $file = Path::Tiny->tempfile;
	Renard::Jacquard::Render::GenerateTree
		->render_tree_to_svg( $render_tree, $file );

	pass;
};

done_testing;
