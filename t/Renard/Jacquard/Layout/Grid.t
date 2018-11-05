#!/usr/bin/env perl

use Test::Most tests => 1;
use Test::Needs qw(SVG Data::Printer);

use Renard::Incunabula::Common::Setup;

use Renard::Jacquard::Actor::Taffeta::Group;
use Renard::Jacquard::Actor::Taffeta::Graphics;

use Renard::Jacquard::Layout::Grid;
use Renard::Jacquard::Layout::All;
use Renard::Jacquard::Layout::Composed;
use Renard::Yarn::Graphene;
use Renard::Jacquard::Content::Rectangle;
use Renard::Taffeta::Color::Named;
use Renard::Taffeta::Style::Fill;
use Renard::Taffeta::Style::Stroke;

use Path::Tiny;

subtest "Create a grid" => sub {
	my $layout = Renard::Jacquard::Layout::Grid->new();
	my $composed = Renard::Jacquard::Layout::Composed->new(
		layouts => [
			Renard::Jacquard::Layout::All->new(),
			$layout,
		],
	);

	my $container = Renard::Jacquard::Actor::Taffeta::Group->new(
		layout => $composed,
	);

	my $actors_bounds = [
		[ 10 , 10 ], [ 10 , 10 ], [ 10 , 10 ],
		[ 10 , 10 ], [ 20 , 10 ], [ 10 , 10 ],
		[ 10 , 30 ], [ 10 , 10 ], [ 10 , 10 ],
		[ 10 , 10 ], [ 10 , 10 ],
	];

	my @actors;
	for my $item_num (0..@$actors_bounds-1) {
		my $actor = Renard::Jacquard::Actor::Taffeta::Graphics->new(
			content => Renard::Jacquard::Content::Rectangle->new(
				width  => $actors_bounds->[$item_num][0],
				height => $actors_bounds->[$item_num][1],
				fill => Renard::Taffeta::Style::Fill->new(
					color => Renard::Taffeta::Color::Named->new( name => 'svg:red' ),
				),
				stroke => Renard::Taffeta::Style::Stroke->new(
					color => Renard::Taffeta::Color::Named->new( name => 'svg:blue' ),
				),
			),
		);

		push @actors, $actor;

		$container->add_child(
			$actor,
			layout => {
				row => int($item_num / 3),
				column => $item_num % 3,
			},
		);
	}

	my $states = $container->layout->update;

	is $states->number_of_actors, 11, 'have the right amount of actors';

	my $get_point = sub {
		my ($actor) = @_;
		$states->get_state($actor)
			->transform
			->apply_to_point([0,0]);
	};
	is $get_point->($actors[ 0]), [  0,  0 ], 'position of actor 0';
	is $get_point->($actors[ 1]), [ 10,  0 ], 'position of actor 1';
	is $get_point->($actors[ 2]), [ 30,  0 ], 'position of actor 2';

	is $get_point->($actors[ 3]), [  0, 10 ], 'position of actor 3';
	is $get_point->($actors[ 4]), [ 10, 10 ], 'position of actor 4';
	is $get_point->($actors[ 5]), [ 30, 10 ], 'position of actor 5';

	is $get_point->($actors[ 6]), [  0, 20 ], 'position of actor 6';
	is $get_point->($actors[ 7]), [ 10, 20 ], 'position of actor 7';
	is $get_point->($actors[ 8]), [ 30, 20 ], 'position of actor 8';

	is $get_point->($actors[ 9]), [  0, 50 ], 'position of actor 9';
	is $get_point->($actors[10]), [ 10, 50 ], 'position of actor 10';



	use Renard::Jacquard::Render::GenerateTree;
	my $file = Path::Tiny->tempfile;
	Renard::Jacquard::Render::GenerateTree
		->render_tree_to_svg(
			Renard::Jacquard::Render::GenerateTree->get_render_tree(
				root => $container ),
			$file );
};

done_testing;
