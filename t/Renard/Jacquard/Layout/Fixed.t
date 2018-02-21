#!/usr/bin/env perl

use Test::Most tests => 1;

use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Actor;
use Renard::Jacquard::Layout::Fixed;

subtest "Create a fixed layout" => sub {
	my $layout = Renard::Jacquard::Layout::Fixed->new();

	my $container = Renard::Jacquard::Actor->new(
		layout => $layout,
	);

	my $actors_positions = [
		[0, 0],
		[5, 5],
		[10, 3],
	];

	my @actors;
	for my $item_num (0..@$actors_positions-1) {
		my $actor = Renard::Jacquard::Actor->new();

		push @actors, $actor;

		$container->add_child(
			$actor,
			layout => {
				x => $actors_positions->[$item_num][0],
				y => $actors_positions->[$item_num][1],
			},
		);
	}

	my $positions = $container->layout->update;

	is scalar keys %$positions, 3, 'have the right amount of actors';

	is $positions->{$actors[0]}, [0, 0], 'position of actor 1';
	is $positions->{$actors[1]}, [5, 5], 'position of actor 2';
	is $positions->{$actors[2]}, [10, 3], 'position of actor 3';
};

done_testing;
