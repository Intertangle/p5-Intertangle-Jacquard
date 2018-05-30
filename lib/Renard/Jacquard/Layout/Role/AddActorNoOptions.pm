use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Role::AddActorNoOptions;
# ABSTRACT: Add actors with no layout options

use Moo::Role;

has _actors => (
	is => 'ro',
	default => sub { [] },
);

=method add_actor

Add actor with no layout-specific options.

=cut
method add_actor($actor) {
	push @{ $self->_actors }, $actor;
}

1;
