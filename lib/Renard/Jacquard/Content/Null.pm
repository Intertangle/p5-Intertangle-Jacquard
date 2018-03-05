use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Null;
# ABSTRACT: Null content

use Moo;
use Renard::Yarn::Graphene;

method bounds( $state ) {
	Renard::Yarn::Graphene::Rect->new(
		origin => Renard::Yarn::Graphene::Point->new(
			x => 0,
			y => 0,
		),
		size => Renard::Yarn::Graphene::Size->new(
			width => 0,
			height => 0,
		),
	)
}

1;
