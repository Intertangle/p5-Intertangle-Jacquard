#!/usr/bin/env perl

use Test::Most tests => 1;

use lib 't/lib';

use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Actor;
use Renard::Jacquard::Layout::Grid;
use Renard::Yarn::Graphene;

subtest "Create a grid" => sub {
	my $layout = Renard::Jacquard::Layout::Grid->new();

	my $container = Renard::Jacquard::Actor->new(
		layout => $layout,
	);

	my $actors_bounds = [
		[ 10 , 10 ], [ 10 , 10 ], [ 10 , 10 ],
		[ 10 , 10 ], [ 20 , 10 ], [ 10 , 10 ],
		[ 10 , 30 ], [ 10 , 10 ], [ 10 , 10 ],
		[ 10 , 10 ], [ 10 , 10 ],
	];

	my @actors;
	for my $item_num (0..@$actors_bounds-1) {
		my $actor = Renard::Jacquard::Actor->new(
			bounds => [
				$actors_bounds->[$item_num][0],
				$actors_bounds->[$item_num][1]
			],
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

	my $positions = $container->layout->update;

	is scalar keys %$positions, 11, 'have the right amount of actors';

	is $positions->{$actors[0]}, [  0,  0 ], 'position of actor 0';
	is $positions->{$actors[1]}, [ 10,  0 ], 'position of actor 1';
	is $positions->{$actors[2]}, [ 30,  0 ], 'position of actor 2';

	is $positions->{$actors[3]}, [  0, 10 ], 'position of actor 3';
	is $positions->{$actors[4]}, [ 10, 10 ], 'position of actor 4';
	is $positions->{$actors[5]}, [ 30, 10 ], 'position of actor 5';

	is $positions->{$actors[6]}, [  0, 20 ], 'position of actor 6';
	is $positions->{$actors[7]}, [ 10, 20 ], 'position of actor 7';
	is $positions->{$actors[8]}, [ 30, 20 ], 'position of actor 8';

	is $positions->{$actors[9]}, [  0, 50 ], 'position of actor 9';
	is $positions->{$actors[10]},[ 10, 50 ], 'position of actor 10';

	use RenderTree;
	RenderTree->render_to_svg($container, path('test.svg'));
};

done_testing;
