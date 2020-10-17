use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Role::Geometry::Position2D;
# ABSTRACT: A 2D geometry with variable position

use Mu::Role;
use Intertangle::Punchcard::Attributes;
use Intertangle::Yarn::Graphene;

variable x =>;
variable y =>;

=method origin_point

...

=cut
method origin_point() {
	Intertangle::Yarn::Graphene::Point->new(
		x => $self->x->value,
		y => $self->y->value,
	);
}

1;
