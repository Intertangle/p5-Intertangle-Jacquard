use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Actor::Attribute::Group;
# ABSTRACT: A group of attributes

use Mu;

extends qw(Renard::Jacquard::Actor);

with qw(Renard::Jacquard::Actor::Role::Tree::TreeDAGNode::WithChildren);

method BUILD() { }

1;
