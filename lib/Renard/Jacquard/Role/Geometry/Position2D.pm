use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Role::Geometry::Position2D;
# ABSTRACT: «TODO»

use Mu::Role;
use Renard::Punchcard::Attributes;
use Renard::Yarn::Graphene;

variable x =>;
variable y =>;

method origin_point() {
	Renard::Yarn::Graphene::Point->new(
		x => $self->x->value,
		y => $self->y->value,
	);
}

1;
