use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Layout::Role::CoordinateSystemTransformable;
# ABSTRACT: Transform the coordinate system

use Moo::Role;
use Renard::Jacquard::Types qw(State);

=method coordinate_system_transform

Returns a state with the coordinate system transform for the given layout.

=cut
method coordinate_system_transform( (State) :$state ) :ReturnType(State) {
	...
}

1;
