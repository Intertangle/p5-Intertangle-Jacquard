use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Box;
# ABSTRACT: «TODO»

use Mu;
use Renard::Punchcard::Backend::Kiwisolver::Context;
use Renard::Punchcard::Attributes;

ro 'margin'; # TODO PositiveOrZeroInt

variable 'outer_x';
variable 'outer_y';

lazy context => sub {
	Renard::Punchcard::Backend::Kiwisolver::Context->new;
};

method create_constraints($actor) {
	my $items = $actor->children;

	my @constraints;

	my $inner_x = $self->context->new_variable( name => "inner.x" );
	my $inner_y = $self->context->new_variable( name => "inner.y" );
	my $inner_width  = $self->context->new_variable( name => "inner.width" );
	my $inner_height = $self->context->new_variable( name => "inner.height" );

	for my $item_no (0..@$items-1) {
		my $this_item = $items->[$item_no];

		push @constraints, $this_item->x >= $inner_x;
		push @constraints, $this_item->y >= $inner_y;

		push @constraints, $inner_width  >= $this_item->width;
		push @constraints, $inner_height >= $this_item->height;
	}

	push @constraints, $self->outer_x + $self->margin == $inner_x;
	push @constraints, $self->outer_y + $self->margin == $inner_y;

	push @constraints, $actor->width == $inner_width + 2 * $self->margin;
	push @constraints, $actor->height == $inner_height + 2 * $self->margin;

	\@constraints;
}

has _constraints => (
	is => 'rw',
	predicate => 1,
);

method update($actor) {
	my $solver = $self->context->solver;
	my $items = $actor->children;
	my $first_item = $items->[0];

	if( ! $self->_has_constraints ) {
		my $constraints = $self->create_constraints( $actor );
		$self->_constraints( $constraints );

		for my $constraint (@$constraints) {
			$solver->add_constraint($constraint);
		}

		$solver->add_edit_variable($self->outer_x, Renard::API::Kiwisolver::Strength::STRONG );
		$solver->add_edit_variable($self->outer_y, Renard::API::Kiwisolver::Strength::STRONG );
	}

	$solver->suggest_value( $self->outer_x, 0);
	$solver->suggest_value( $self->outer_y, 0);
	$solver->update;
}

1;
