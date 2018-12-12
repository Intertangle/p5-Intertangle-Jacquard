use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Grid;
# ABSTRACT: A grid layout

use Renard::Incunabula::Common::Types qw(PositiveOrZeroInt PositiveInt ArrayRef);

use Moo;
use List::AllUtils qw(max);
use MooX::HandlesVia;
use MooseX::HandlesConstructor;
use Renard::Taffeta::Transform::Affine2D::Translation;

=method BUILD

Supports setting handles C<intergrid_space_rows>, C<intergrid_space_columns> at
construction time in addition to the other attributes.

=cut


=attr intergrid_space

How much space to add between grid rows/columns.

Either use a single number to set both rows and columns or a tuple to set both independently.

=attr intergrid_space_rows

How much space to add between grid rows.

Implemented as a handle for C<intergrid_space>, but can be set at construction time.

=attr intergrid_space_columns

How much space to add between grid columns.

Implemented as a handle for C<intergrid_space>, but can be set at construction time.

=cut
has intergrid_space => (
	is => 'ro',
	isa => ArrayRef,
	coerce => sub {
		@_ == 1 && ! ref $_[0] ?  [ $_[0], $_[0] ] : $_[0]
	},
	default => sub { [ 0, 0 ] },
	handles_via => 'Array',
	handles => {
		intergrid_space_rows    => [ accessor => 0 ],
		intergrid_space_columns => [ accessor => 1 ],
	},
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
method update( :$state ) {
	my @actors = keys %{ $self->_data };

	$self->_logger->tracef( "Updating %s: got ", $self  );

	my $actor_to_grid = {};
	my $grid_by_row = {};
	my $grid_by_col = {};
	tie my %bounds_by_actor, 'Tie::RefHash';
	my $bounds_by_actor = \%bounds_by_actor;
	for my $actor (@actors) {
		my $r = $self->_data->{ $actor }{row};
		my $c = $self->_data->{ $actor }{column};

		$actor_to_grid->{$actor} = [ $r , $c ];
		push @{ $grid_by_row->{$r} }, $actor;
		push @{ $grid_by_col->{$c} }, $actor;

		my $state = defined $state ? $state : $self->input->get_state( $actor );
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

	my $mingrid_space = $self->mingrid_space;

	my $grid_corner = {};
	my $row_corner = [ 0 ]; # row 0 starts at y = 0
	$self->_rows(1 + max keys %$max_height_by_row);
	for my $row (1..$self->_rows - 1) {
		push @$row_corner, $row_corner->[-1]
			+ $self->intergrid_space_rows
			+ $max_height_by_row->{$row - 1} // $mingrid_space
			;
	}

	my $col_corner = [ 0 ]; # col 0 starts at x = 0
	$self->_columns(1 + max keys %$max_width_by_col);
	for my $col (1..$self->_columns - 1) {
		push @$col_corner, $col_corner->[-1]
			+ $self->intergrid_space_columns
			+ $max_width_by_col->{$col - 1} // $mingrid_space
			;
	}

	my $output = Renard::Jacquard::Render::StateCollection->new;
	for my $actor (@actors) {
		my $input_state = defined $state ? $state : $self->input->get_state( $actor );
		my $translate = Renard::Taffeta::Transform::Affine2D::Translation->new(
			translate => [
				$col_corner->[ $actor_to_grid->{$actor}[1] ],
				$row_corner->[ $actor_to_grid->{$actor}[0] ],
			],
		);
		my $state = Renard::Jacquard::Render::State->new(
			coordinate_system_transform => $translate,
		);

		my $composed = $input_state->compose($state);
		$output->set_state( $actor, $composed );
		$composed->r_bounds( $actor );
	}

	$output;
}

with qw(
	Renard::Jacquard::Layout::Role::WithInputStateCollection
	MooX::Role::Logger
);

1;
