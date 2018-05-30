use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Role::GeometryTransformable;
# ABSTRACT: Transform the geometry of an actor

use Moo::Role;
use Renard::Jacquard::Types qw(State);

=method geometry_transform

Returns a State with the geometry transform for the layout.

=cut
method geometry_transform( (State) :$state ) :ReturnType(State) {
	...
}

1;
