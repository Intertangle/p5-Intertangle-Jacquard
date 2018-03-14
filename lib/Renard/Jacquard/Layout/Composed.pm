use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Composed;
# ABSTRACT: A layout composed of other layouts

use Moo;
use Renard::Incunabula::Common::Types qw(ArrayRef);

=attr layouts

An C<ArrayRef> of layouts to compose.

=cut
has layouts => (
	is => 'ro',
	isa => ArrayRef,
	default => sub { [ Renard::Jacquard::Layout::All->new ] },
);

=method add_actor

Add actor to each of the layouts.

=cut
method add_actor(@) {
	for my $layout ( @{ $self->layouts } ) {
		$layout->add_actor( @_ );
	}
}

=method update

Update layout.

=cut
method update(@) {
	my $output = $self->layouts->[0]->update(@_);
	my @layouts = @{ $self->layouts };
	for my $layout ( @layouts[1..$#layouts] ) {
		$layout->input( $output );
		$output = $layout->update();
	}

	$output;
}

1;
