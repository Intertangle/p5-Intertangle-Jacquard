use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Role::LimitedGrid;
# ABSTRACT: A grid with limits

use Mu::Role;
use Renard::Incunabula::Common::Types qw(PositiveInt Bool);
use Renard::Jacquard::Error;

has [qw(rows columns)] => (
	is => 'rw',
	required => 1,
	isa => PositiveInt,
);

lazy _maximum_number_of_items => method() {
	$self->rows * $self->columns;
}, isa => PositiveInt;

method can_add_more_actors() :ReturnType(Bool) {
	$self->number_of_actors < $self->_maximum_number_of_items;
}

before add_actor => method( @ ) {
	if( ! $self->can_add_more_actors ) {
		Renard::Jacquard::Error::Layout::MaximumNumberOfActors->throw({
			msg => "Can not add more than @{[ $self->_maximum_number_of_items ]} actor(s)",
			data => { maximum => $self->_maximum_number_of_items },
		});
	}
};

1;
