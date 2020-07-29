use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Role::Render::QnD::SVG::Group;
# ABSTRACT: Quick-and-dirty SVG group rendering

use Moo::Role;

method render($svg) {
	my $group = $svg->group;
	for my $child (@{$self->children}) {
		$child->render($group);
	}
}

with qw(Renard::Jacquard::Role::Render::QnD::SVG);

1;
