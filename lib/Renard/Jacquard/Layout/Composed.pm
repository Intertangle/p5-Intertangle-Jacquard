use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Composed;
# ABSTRACT: A layout composed of other layouts

use Moo;
use Renard::Incunabula::Common::Types qw(ArrayRef);

has layouts => (
	is => 'ro',
	isa => ArrayRef,
	default => sub { [ Renard::Jacquard::Layout::All->new ] },
);

method add_actor(@) {
	for my $layout ( @{ $self->layouts } ) {
		$layout->add_actor( @_ );
	}
}

method update() {
	my $output = $self->layouts->[0]->update();
	my @layouts = @{ $self->layouts };
	for my $layout ( @layouts[1..$#layouts] ) {
		$layout->input( $output );
		$output = $layout->update()
	}

	$output;
}

1;
