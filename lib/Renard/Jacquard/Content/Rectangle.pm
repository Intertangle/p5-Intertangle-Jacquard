use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Rectangle;
# ABSTRACT: Rectangle content

use Mu;
use MooX::ClassAttribute;
use Renard::Incunabula::Common::Types qw(ClassName);
use Renard::Taffeta::Graphics::Rectangle;

class_has taffeta_class => (
	is => 'ro',
	isa => ClassName,
	default => 'Renard::Taffeta::Graphics::Rectangle',
);

with qw(Renard::Jacquard::Content::Role::Graphics::Taffeta);

1;
