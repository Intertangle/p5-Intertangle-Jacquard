use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Image::PNG;
# ABSTRACT: PNG data content

use Mu;
use Renard::Incunabula::Common::Types qw(ClassName);
use Renard::Taffeta::Graphics::Image::PNG;

=classmethod taffeta_class

Returns L<Renard::Taffeta::Graphics::Image::PNG>.

=cut
classmethod taffeta_class() :ReturnType(ClassName) {
	'Renard::Taffeta::Graphics::Image::PNG';
}

=method BUILDARGS

Takes L<Renard::Taffeta::Graphics::Image::PNG> attributes and stores them.

=cut

with qw(Renard::Jacquard::Content::Role::TaffetaDelegate);

1;
