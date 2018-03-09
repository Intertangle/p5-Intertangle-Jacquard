use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Bounds::Limited;
# ABSTRACT: A representation of limited bounds

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);

has bounds => (
	is => 'ro',
	isa => InstanceOf['Renard::Yarn::Graphene::Rect'],
);

1;
