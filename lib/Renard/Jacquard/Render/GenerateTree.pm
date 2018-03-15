use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Render::GenerateTree;
# ABSTRACT: Walk the scene graph and generate tree

use Moo;
use Renard::Jacquard::Render::State;
use Path::Tiny;
use Renard::Jacquard::Layout::All;
use Renard::Jacquard::Layout::Composed;
use Tree::DAG_Node;

=method get_render_tree

Returns a L<Tree::DAG_Node> of renderable objects.

=cut
method get_render_tree(
	:$root,
	:$state = Renard::Jacquard::Render::State->new,
	) {

	my $tree = Tree::DAG_Node->new;

	if( ref $root->content ne 'Renard::Jacquard::Content::Null' ) {
		my $taffeta = $root->content->as_taffeta(
			state => $state,
		);

		$tree->attributes({
			render => $taffeta,
		});
	} else {
		my $layout;
		my $states;
		#if( ref $root->layout ne 'Renard::Jacquard::Layout::Composed' ) {
			$states = $root->layout->update( state => $state );
		#} else {
			#$states = $root->layout->update;
		#}
		my $children = $root->children;

		for my $child (@$children) {
			my $new_state = $states->get_state( $child );
			$tree->add_daughter(
				$self->get_render_tree(
					root     => $child,
					state    => $new_state,
				)
			);
		}
	}
	$tree->attributes->{bounds} = $root->bounds( $state );
	$tree->attributes->{state} =  $state;

	$tree;
}

=method render_tree_to_svg

Renders the result of C<get_render_tree> to an SVG file.

=cut
method render_tree_to_svg( $render_tree, $path  ) {
	require SVG;
	my $svg = SVG->new;

	method walker( $node, $svg ) {
		my @daughters = $node->daughters;
		if( exists $node->attributes->{render} ) {
			my $el = $node->attributes->{render}->render_svg( $svg );
			$self->_add_debug_tooltips( $node, $el );
		}
		my $group = @daughters > 1 ? $svg->group : $svg ;
		for my $daughter (@daughters) {
			$self->walker( $daughter, $group );
		}
	};

	$self->walker( $render_tree, $svg->group );

	path($path)->spew_utf8($svg->xmlify);
}

method _add_debug_tooltips( $node, $element ) {
	require DDP;
	my %options = (
		multiline => 0,
		colored => 0,
	);
	my $bounds_str = Data::Printer::np($node->attributes->{bounds}, %options, class => { expand => 'all' } );
	my $state_str  = Data::Printer::np($node->attributes->{state}->transform->matrix, %options, class => { expand => 'all' } );
	my $render_str  = Data::Printer::np($node->attributes->{render}, %options, class => { expand => '1' } );

	my $title = $element->tag('title')->cdata_noxmlesc(<<"EOF");

<foreignObject>
	<body xmlns="http://www.w3.org/1999/xhtml">
		<code>
			<pre>
$state_str
			</pre>
		</code>
		<code>
			<pre>
$bounds_str
			</pre>
		</code>
		<code>
			<pre>
$render_str
			</pre>
		</code>
</body>
</foreignObject>
EOF

}

1;
