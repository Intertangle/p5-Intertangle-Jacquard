use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Role::Render::QnD::SVG::Group;
# ABSTRACT: Quick-and-dirty SVG group rendering

use Moo::Role;

=method render

...

=cut
method render($svg) {
	my $group = $svg->group( transform => "translate(@{[ $self->x->value ]},@{[ $self->y->value ]})" );
	for my $child (@{$self->children}) {
		$child->render($group);
	}
}

with qw(Intertangle::Jacquard::Role::Render::QnD::SVG);

1;
