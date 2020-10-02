use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Role::Render::QnD::Bounds::Group;
# ABSTRACT: Quick-and-dirty group bounds

use Moo::Role;
use Intertangle::Yarn::Graphene;
use Intertangle::Yarn::Types qw(Point Size);

method bounds() {
	my $rect = Intertangle::Yarn::Graphene::Rect->new(
		origin => $self->children->[0]->origin_point,
		size => $self->children->[0]->size,
	);
	for my $child (@{ $self->children }) {
		$rect = $rect->union( $child->bounds );
	}

	$rect;
}

1;
