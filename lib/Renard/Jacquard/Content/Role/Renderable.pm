use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Role::Renderable;
# ABSTRACT: A role for renderable objects

use Moo::Role;
use Renard::Incunabula::Common::Types qw(InstanceOf);
use Renard::Jacquard::Render::State;

=method as_taffeta

Returns a Taffeta graphics object for the content.

=cut
method as_taffeta(
	(InstanceOf['Renard::Jacquard::Render::State']) :$state = Renard::Jacquard::Render::State->new,
	:$taffeta_args = {} ) {
	...
}

1;
