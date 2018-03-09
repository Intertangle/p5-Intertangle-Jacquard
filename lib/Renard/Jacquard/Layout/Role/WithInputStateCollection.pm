use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Role::WithInputStateCollection;
# ABSTRACT: A role that provides an input state collection

use Moo::Role;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Jacquard::Render::StateCollection;

has input => (
	is => 'rw',
	isa => InstanceOf['Renard::Jacquard::Render::StateCollection'],
);

1;
