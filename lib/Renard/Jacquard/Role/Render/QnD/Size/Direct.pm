use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Role::Render::QnD::Size::Direct;
# ABSTRACT: Quick-and-dirty role for computing size from width / height

use Mu::Role;

lazy size => method() {
	Renard::Yarn::Graphene::Size->new(
		height => ref $self->height ? $self->height->value : $self->height,
		width => ref $self->width ? $self->width->value : $self->width,
	);
};

1;
