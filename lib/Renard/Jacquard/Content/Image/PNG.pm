use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Image::PNG;
# ABSTRACT: PNG data content

use Mu;
use MooX::ClassAttribute;
use Renard::Incunabula::Common::Types qw(ClassName);
use Renard::Taffeta::Graphics::Image::PNG;

class_has taffeta_class => (
	is => 'ro',
	isa => ClassName,
	default => 'Renard::Taffeta::Graphics::Image::PNG',
);

=method BUILDARGS

Takes L<Renard::Taffeta::Graphics::Image::PNG> attributes and stores them.

=cut

with qw(Renard::Jacquard::Content::Role::TaffetaDelegate);

1;
