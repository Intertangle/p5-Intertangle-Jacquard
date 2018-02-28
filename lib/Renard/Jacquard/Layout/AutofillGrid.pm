use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::AutofillGrid;
# ABSTRACT: A grid of limited size that is filled sequentially

use Renard::Incunabula::Common::Types qw(Tuple PositiveOrZeroInt Enum Dict);

use Mu;

extends qw(Renard::Jacquard::Layout::Grid);

=attr fill_major_order

One of

- row
- column

for row-major and column-major order respectively.

=cut
has fill_major_order => (
	is => 'ro',
	default => sub { 'row' },
	isa => Enum['row', 'column'],
);

=attr fill_start_corner

One of

- top-left
- top-right
- bottom-left
- bottom-right

=cut
has fill_start_corner => (
	is => 'ro',
	default => sub { 'top-left' },
	isa => Enum['top-left', 'top-right', 'bottom-left', 'bottom-right'],
);

=method number_of_actors

Number of actors currently in the grid.

=cut
method number_of_actors() :ReturnType(PositiveOrZeroInt) {
	scalar keys %{ $self->_data };
}

=method get_row_column

Returns the row and column for the C<$actor> as a tuple.

=cut
method get_row_column( $actor ) :ReturnType( list => Tuple[PositiveOrZeroInt,PositiveOrZeroInt]) {
	my $data = $self->_data->{$actor};

	( $data->{row}, $data->{column} );
}

=method _item_number_to_row_column

Example of how the layout works:

  1 2
  3 4
  
  top-left:
  
      row:    LR: 1 2 3 4
      column: TB: 1 3 2 4
  
  top-right:
  
      row:    RL: 2 1 4 3
      column: TB: 2 4 1 3
  
  bottom-left:
  
      row:    LR: 3 4 1 2
      column: BT: 3 1 4 2
  
  bottom-right:
  
      row:    RL: 4 3 2 1
      column: BT: 4 2 3 1


=cut
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

=method add_actor

Adds an actor sequentially to the grid.

This only allows a single actor to occupy a space in the grid.

=cut
method add_actor( $actor ) {
	my $item_num = $self->number_of_actors;
	$self->SUPER::add_actor(
		$actor,
		$self->_item_number_to_row_column( $item_num ),
	)
}

with qw(Renard::Jacquard::Layout::Role::LimitedGrid);

1;
