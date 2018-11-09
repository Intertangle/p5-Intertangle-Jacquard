use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Graph::Taffeta;
# ABSTRACT: A Taffeta scene graph

use Moo;
use Renard::Incunabula::Common::Types qw(InstanceOf);

use Renard::Jacquard::Graph::Render;

has graph => (
	is => 'ro',
	isa =>
		InstanceOf['Renard::Jacquard::Actor::Taffeta::Group']
		| InstanceOf['Renard::Jacquard::Actor::Taffeta::Graphics'],
	required => 1,
);

method to_render_graph() {
	my $gen = Renard::Jacquard::Render::GenerateTree->new;
	return Renard::Jacquard::Graph::Render->new(
		graph => $gen->get_render_tree(
			root => $self->graph,
		)
	);
}

1;
