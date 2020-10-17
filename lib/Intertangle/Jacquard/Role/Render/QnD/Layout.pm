use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Role::Render::QnD::Layout;
# ABSTRACT: Quick-and-dirty layout role

use Moo::Role;

=attr layout

...

=cut
has layout => (
	is => 'ro',
	required => 1,
);

=method update_layout

...

=cut
method update_layout() {
	$self->layout->update($self);
}

1;
