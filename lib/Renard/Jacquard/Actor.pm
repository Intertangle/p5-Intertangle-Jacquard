use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor;
# ABSTRACT: Base class for scene graph objects

use Moo;

with qw(
	Renard::Jacquard::Actor::Role::Tree::TreeDAGNode
	Renard::Jacquard::Actor::Role::Tree::TreeDAGNode::WithChildren
);

method BUILD(@) { }

1;
