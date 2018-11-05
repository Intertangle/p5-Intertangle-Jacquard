use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Rectangle;
# ABSTRACT: Rectangle content

use Mu;
use Renard::Incunabula::Common::Types qw(ClassName);
use Renard::Taffeta::Graphics::Rectangle;

classmethod taffeta_class() :ReturnType(ClassName) {
	'Renard::Taffeta::Graphics::Rectangle';
}

=method BUILDARGS

Takes L<Renard::Taffeta::Graphics::Rectangle> attributes and stores them.

=cut

with qw(Renard::Jacquard::Content::Role::TaffetaDelegate);

1;
