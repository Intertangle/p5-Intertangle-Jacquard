#!/usr/bin/env perl

use Test::Most tests => 3;

use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Layout::AutofillGrid;
use Renard::Jacquard::Actor;

subtest "Default grid actors" => sub {
	my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
		rows => 2,
		columns => 3,
	);
	my @actors = map { Renard::Jacquard::Actor->new } 0..5;

	$grid->add_actor( $_ ) for @actors;

	my $test_actor_rc = sub {
		my ($grid, $actor, $r, $c) = @_;
		my @rc = $grid->get_row_column( $actor );

		is_deeply( \@rc, [ $r, $c ], "actor is at [ $r, $c ]")
	};

	$test_actor_rc->($grid, $actors[0], 0, 0);
	$test_actor_rc->($grid, $actors[1], 0, 1);
	$test_actor_rc->($grid, $actors[2], 0, 2);
	$test_actor_rc->($grid, $actors[3], 1, 0);
	$test_actor_rc->($grid, $actors[4], 1, 1);
	$test_actor_rc->($grid, $actors[5], 1, 2);
};

subtest 'Fill order' => sub {
	# 1 2
	# 3 4
	# 5 6
	my $index_to_rc = {
		1 => { row => 0, column => 0 },
		2 => { row => 0, column => 1 },
		3 => { row => 1, column => 0 },
		4 => { row => 1, column => 1 },
		5 => { row => 2, column => 0 },
		6 => { row => 2, column => 1 },
	};

	my $number_of_actors = 6;
	my @default_args = ( rows => 3, columns => 2 );

	is( { @default_args }->{rows} * { @default_args }->{columns}, $number_of_actors, 'right number of actors' );

	my $check_data = sub {
		my ($grid, $data) = @_;

		plan tests => $number_of_actors;

		my $table = [];
		for my $n (0..$number_of_actors-1) {
			my $result = { $grid->_item_number_to_row_column( $n ) };
			my $rc = $index_to_rc->{ $data->[ $n ] };

			$table->[$result->{row}][$result->{column}] = $n;

			is_deeply(
				$result,
				$rc,
				"$n -> [ @{[ $rc->{row} ]} , @{[ $rc->{column} ]} ]"
			);
		}

		my $table_str = "";
		$table_str .= "Visualisation of grid order:\n";
		for my $r (@$table) {
			$table_str .= sprintf( "  | %d | %d |\n", @$r );
		}
		note $table_str;
	};

	subtest 'top-left row' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'top-left',
			fill_major_order => 'row',
		);
		my $data = [ 1, 2, 3, 4, 5, 6, ];
		$check_data->($grid, $data);
	};
	subtest 'top-left column' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'top-left',
			fill_major_order => 'column',
		);
		my $data = [ 1, 3, 5, 2, 4, 6 ];
		$check_data->($grid, $data);
	};

	subtest 'top-right row' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'top-right',
			fill_major_order => 'row',
		);
		my $data = [ 2, 1, 4, 3, 6, 5 ];
		$check_data->($grid, $data);
	};
	subtest 'top-right column' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'top-right',
			fill_major_order => 'column',
		);
		my $data = [ 2, 4, 6, 1, 3, 5 ];
		$check_data->($grid, $data);
	};


	subtest 'bottom-left row' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'bottom-left',
			fill_major_order => 'row',
		);
		my $data = [ 5, 6, 3, 4, 1, 2 ];
		$check_data->($grid, $data);
	};
	subtest 'bottom-left column' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'bottom-left',
			fill_major_order => 'column',
		);
		my $data = [ 5, 3, 1, 6, 4, 2 ];
		$check_data->($grid, $data);
	};

	subtest 'bottom-right row' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'bottom-right',
			fill_major_order => 'row',
		);
		my $data = [ 6, 5, 4, 3, 2, 1 ];
		$check_data->($grid, $data);
	};
	subtest 'bottom-right column' => sub {
		my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
			@default_args,
			fill_start_corner => 'bottom-right',
			fill_major_order => 'column',
		);
		my $data = [ 6, 4, 2, 5, 3, 1 ];
		$check_data->($grid, $data);
	};
};

subtest "Grid is limited" => sub {
	my $grid = Renard::Jacquard::Layout::AutofillGrid->new(
		rows => 2,
		columns => 3,
	);
	$grid->add_actor(
		Renard::Jacquard::Actor->new
	) for 0..5;

	throws_ok {
		# adding an extra actor throws an exception
		$grid->add_actor( Renard::Jacquard::Actor->new );
	} 'Renard::Jacquard::Error::Layout::MaximumNumberOfActors';

};

done_testing;
