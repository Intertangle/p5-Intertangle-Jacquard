use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::AutofillGrid;
# ABSTRACT: A grid of limited size that is filled sequentially

use Renard::Incunabula::Common::Types qw(Tuple PositiveOrZeroInt Enum Dict);

use Mu;

extends qw(Renard::Jacquard::Layout::Grid);

=attr fill_direction


1 2
3 4

TL:
	row: LR: 1 2 3 4
	column: TB: 1 3 2 4

TR:
	row: RL: 2 1 4 3
	column: TB: 2 4 1 3

BL:
	row: LR: 3 4 1 2
	column: BT: 3 1 4 2

BR:
	row: RL: 4 3 2 1
	column: BT: 4 2 3 1


TODO row_major_left_to_right, row_major_right_to_left
column_major_top_to_bottom, column_major_bottom_to_top

=cut
has fill_major_order => (
	is => 'ro',
	default => sub { 'row' },
	isa => Enum['row', 'column'],
);

has fill_start_corner => (
	is => 'ro',
	default => sub { 'top-left' },
	isa => Enum['top-left', 'top-right', 'bottom-left', 'bottom-right'],
);

method number_of_actors() :ReturnType(PositiveOrZeroInt) {
	scalar keys %{ $self->_data };
}

method get_row_column( $actor ) :ReturnType( list => Tuple[PositiveOrZeroInt,PositiveOrZeroInt]) {
	my $data = $self->_data->{$actor};

	( $data->{row}, $data->{column} );
}

method _item_number_to_row_column( (PositiveOrZeroInt) $number )
	:ReturnType( list => Dict[ row => PositiveOrZeroInt, column => PositiveOrZeroInt ]) {

	my ($row, $column);
	if( $self->fill_major_order eq 'row' ) {
		# columns change the fastest ⇒ %
		my $lr_column =      $number % $self->columns;
		my $lr_row    = int( $number / $self->columns );

		if( $self->fill_start_corner =~ /-left$/ ) {
			# LR: top-left, bottom-left
			$column = $lr_column;
		} elsif( $self->fill_start_corner =~ /-right$/ ) {
			# RL: top-right, bottom-right
			$column = $self->columns - 1 - $lr_column;
		}

		if( $self->fill_start_corner =~ /^top-/ ) {
			# top-right, top-left
			$row = $lr_row;
		} elsif( $self->fill_start_corner =~ /^bottom-/ ) {
			# bottom-right, bottom-left
			$row = $self->rows - 1 - $lr_row;
		}
	} elsif( $self->fill_major_order eq 'column' ) {
		# rows change the fastest ⇒ %
		my $tb_row    =      $number % $self->rows;
		my $tb_column = int( $number / $self->rows );

		if( $self->fill_start_corner =~ /-left$/ ) {
			# top-left, bottom-left
			$column = $tb_column;
		} elsif( $self->fill_start_corner =~ /-right$/ ) {
			# top-right, bottom-right
			$column = $self->columns - 1 - $tb_column;
		}

		if( $self->fill_start_corner =~ /^top-/ ) {
			# TB: top-right, top-left
			$row = $tb_row;
		} elsif( $self->fill_start_corner =~ /^bottom-/ ) {
			# BT: bottom-right, bottom-left
			$row = $self->rows - 1 - $tb_row;
		}
	} else {
		...
	}

	return (
		row => $row,
		column => $column,
	);
}

method add_actor( $actor ) {
	my $item_num = $self->number_of_actors;
	$self->SUPER::add_actor(
		$actor,
		$self->_item_number_to_row_column( $item_num ),
	)
}

with qw(Renard::Jacquard::Layout::Role::LimitedGrid);

1;
