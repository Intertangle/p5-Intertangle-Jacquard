use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Role::Render::QnD::Layout;
# ABSTRACT: Quick-and-dirty layout role

use Moo::Role;

has layout => (
	is => 'ro',
	required => 1,
);

method update_layout() {
	$self->layout->update($self);
}

1;
