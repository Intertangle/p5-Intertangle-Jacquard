use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Role::Render::QnD::Size::Direct;
# ABSTRACT: Quick-and-dirty role for computing size from width / height

use Mu::Role;

lazy size => method() {
	Renard::Yarn::Graphene::Size->new(
		height => $self->height->value,
		width => $self->width->value,
	);
};

1;
