use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Types;
# ABSTRACT: Type library for Jacquard

use Type::Library 0.008 -base,
	-declare => [qw(
		Actor
		State
	)];
use Type::Utils -all;

use Renard::Incunabula::Common::Types qw(InstanceOf);

=type Actor

A type for any reference that extends L<Intertangle::Jacquard::Actor>.

=cut
class_type "Actor",
	{ class => 'Intertangle::Jacquard::Actor' };

=type State

A type for any reference that extends L<Intertangle::Jacquard::Render::State>.

=cut
class_type "State",
	{ class => "Intertangle::Jacquard::Render::State" };

1;
