use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Grid;
# ABSTRACT: A grid layout

use Renard::Incunabula::Common::Types qw(PositiveOrZeroInt PositiveInt);

use Moo;
use List::AllUtils qw(max);
use Renard::Taffeta::Transform::Affine2D::Translation;

=attr intergrid_space

How much space to add between grids spots.

=cut
has intergrid_space => (
	is => 'ro',
	default => sub { 0 },
);

=attr mingrid_space

Minimum space to use for a grid space when it is empty.

=cut
has mingrid_space => (
	is => 'ro',
	default => sub { 0 },
);

=attr _rows

=attr _columns

Current maximum number of rows or columns

=cut
has [qw(_rows _columns)] => (
	is => 'rw',
	isa => PositiveInt,
);

=attr _data

Holds position data for each actor.

=cut
has _data => (
	is =>'ro',
	default => sub {
		my %hash;
		tie %hash, 'Tie::RefHash';
		\%hash;
	},
);

=method add_actor

Add an actor the grid.

=cut
method add_actor( $actor, (PositiveOrZeroInt) :$row, (PositiveOrZeroInt) :$column ) {
	$self->_data->{ $actor } = { row => $row, column => $column };
}

=method update

Layout the actors.

=cut
method update() {
	my @actors = keys %{ $self->_data };

	my $actor_to_grid = {};
	my $grid_by_row = {};
	my $grid_by_col = {};
	my $bounds_by_actor = {};
	for my $actor (@actors) {
		my $r = $self->_data->{ $actor }{row};
		my $c = $self->_data->{ $actor }{column};

		$actor_to_grid->{$actor} = [ $r , $c ];
		push @{ $grid_by_row->{$r} }, $actor;
		push @{ $grid_by_col->{$c} }, $actor;

		my $state = $self->input->get_state( $actor );
		$bounds_by_actor->{$actor} = $actor->bounds( $state );
	}

	my $max_height_by_row = {
		map {
			my @actors = @{ $grid_by_row->{$_} };
			my $max_height = max map {
				my $actor = $_;
				$bounds_by_actor->{$actor}->size->height;
			} @actors;

			$_ => $max_height;
		} keys %$grid_by_row
	};

	my $max_width_by_col = {
		map {
			my @actors = @{ $grid_by_col->{$_} };
			my $max_width = max map {
				my $actor = $_;
				$bounds_by_actor->{$actor}->size->width;
			} @actors;

			$_ => $max_width;
		} keys %$grid_by_col
	};

	my $intergrid_space = $self->intergrid_space;
	my $mingrid_space = $self->mingrid_space;

	my $grid_corner = {};
	my $row_corner = [ 0 ]; # row 0 starts at y = 0
	$self->_rows(1 + max keys %$max_height_by_row);
	for my $row (1..$self->_rows - 1) {
		push @$row_corner, $row_corner->[-1]
			+ $intergrid_space
			+ $max_height_by_row->{$row - 1} // $mingrid_space
			;
	}

	my $col_corner = [ 0 ]; # col 0 starts at x = 0
	$self->_columns(1 + max keys %$max_width_by_col);
	for my $col (1..$self->_columns - 1) {
		push @$col_corner, $col_corner->[-1]
			+ $intergrid_space
			+ $max_width_by_col->{$col - 1} // $mingrid_space
			;
	}

	my $output = Renard::Jacquard::Render::StateCollection->new;
	for my $actor (@actors) {
		my $input_state = $self->input->get_state( $actor );
		my $translate = Renard::Taffeta::Transform::Affine2D::Translation->new(
			translate => [
				$col_corner->[ $actor_to_grid->{$actor}[1] ],
				$row_corner->[ $actor_to_grid->{$actor}[0] ],
			],
		);
		my $state = Renard::Jacquard::Render::State->new(
			transform => $translate,
		);

		$output->set_state( $actor, $input_state->compose($state) );
	}

	$output;
}

with qw(Renard::Jacquard::Layout::Role::WithInputStateCollection);

1;
