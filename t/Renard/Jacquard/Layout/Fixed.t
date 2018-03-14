#!/usr/bin/env perl

use Test::Most tests => 1;

use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Actor;
use Renard::Jacquard::Layout::Fixed;
use Renard::Jacquard::Layout::All;
use Renard::Jacquard::Layout::Composed;

subtest "Create a fixed layout" => sub {
	my $layout = Renard::Jacquard::Layout::Fixed->new();
	my $composed = Renard::Jacquard::Layout::Composed->new(
		layouts => [
			Renard::Jacquard::Layout::All->new(),
			$layout,
		],
	);

	my $container = Renard::Jacquard::Actor->new(
		layout => $composed,
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

	my $states = $container->layout->update;

	is $states->number_of_actors, 3, 'have the right amount of actors';

	my $get_point = sub {
		my ($actor) = @_;
		$states->get_state($actor)
			->transform
			->apply_to_point([0,0]);
	};
	is $get_point->($actors[0]), [0, 0], 'position of actor 1';
	is $get_point->($actors[1]), [5, 5], 'position of actor 2';
	is $get_point->($actors[2]), [10, 3], 'position of actor 3';
};

done_testing;
