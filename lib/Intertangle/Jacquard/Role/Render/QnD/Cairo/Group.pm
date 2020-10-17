use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Role::Render::QnD::Cairo::Group;
# ABSTRACT: Quick-and-dirty Cairo group rendering

use Mu::Role;

=method render_cairo

...

=cut
method render_cairo($cr) {
	$cr->save;
	my $matrix = Cairo::Matrix->init_translate( $self->x->value, $self->y->value )
	->multiply(
		$cr->get_matrix
	);
	$cr->set_matrix( $matrix );
	for my $child (@{$self->children}) {
		$child->render_cairo($cr);
	}
	$cr->restore;
}

with qw(Intertangle::Jacquard::Role::Render::QnD::Cairo);

1;
