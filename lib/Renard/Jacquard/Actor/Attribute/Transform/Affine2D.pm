use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Attribute::Transform::Affine2D;
# ABSTRACT: Affine2D transform attribute

use Mu;
use Renard::Incunabula::Common::Types qw(InstanceOf);

extends qw(Renard::Jacquard::Actor);

=attr transform

The C<Renard::Taffeta::Transform::Affine2D> transform to apply to each child.

=cut
has transform => (
	is => 'ro',
	isa => InstanceOf['Renard::Taffeta::Transform::Affine2D'],
	default => sub {
		Renard::Taffeta::Transform::Affine2D->new
	},
);

method attribute( $state ) {
	...
}

with qw(Renard::Jacquard::Actor::Role::DataPrinter);
method _data_printer_internal() { $self->transform }

1;
