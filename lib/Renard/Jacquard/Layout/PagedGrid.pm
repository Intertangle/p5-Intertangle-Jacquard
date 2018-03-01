use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::PagedGrid;
# ABSTRACT: A grid layout that allows paging

use Renard::Incunabula::Common::Types qw(ArrayRef InstanceOf PositiveInt Maybe);

use Moo;

has [qw(rows columns)] => (
	is => 'rw',
	required => 1,
	isa => Maybe[PositiveInt],
);

has _grids => (
	is => 'ro',
	default => sub { [] },
	isa => ArrayRef[InstanceOf['Renard::Jacquard::Layout::AutofillGrid']],
);

method add_actor( $actor ) {
	...
}


1;
