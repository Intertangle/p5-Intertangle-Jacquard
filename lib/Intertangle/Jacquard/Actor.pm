use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Actor;
# ABSTRACT: Base class for scene graph objects

use Moo;

with qw(
	Intertangle::Jacquard::Actor::Role::Tree::TreeDAGNode
	Intertangle::Jacquard::Actor::Role::Tree::TreeDAGNode::WithChildren
);

=method BUILD

C<BUILD> for base class.

=cut
method BUILD(@) { }

1;
