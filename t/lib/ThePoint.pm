use Renard::Incunabula::Common::Setup;
package ThePoint;
# ABSTRACT: Generate a tree

use aliased 'Renard::Jacquard::Actor';
use aliased 'Renard::Jacquard::Layout::Fixed';
use aliased 'Renard::Jacquard::Layout::All';
use aliased 'Renard::Jacquard::Layout::Affine2D';
use aliased 'Renard::Jacquard::Layout::AutofillGrid';
use aliased 'Renard::Jacquard::Layout::Composed';
use aliased 'Renard::Jacquard::Content::Rectangle';
use Renard::Taffeta::Color::Named;
use Renard::Taffeta::Style::Fill;
use Renard::Taffeta::Style::Stroke;
use Renard::Taffeta::Transform::Affine2D::Scaling;

#use Log::Any::Adapter;
#Log::Any::Adapter->set('Stdout',
	##min_level => 'trace',
	##use_color => 1, # force color even when not interactive
	## stderr    => 0, # print to STDOUT instead of the default STDERR
#);

fun create_page_node( :$fill = 'svg:black' ) {
	my $page_group = Actor->new(
		layout => Fixed->new
	);

	my $rect = Rectangle->new(
		width  => 100,
		height => 200,
		fill   => Renard::Taffeta::Style::Fill->new(
			color => Renard::Taffeta::Color::Named->new( name => $fill ),
		),
		stroke => Renard::Taffeta::Style::Stroke->new(
			color => Renard::Taffeta::Color::Named->new( name => 'svg:blue' ),
		),
	);
	$page_group->add_child(
		Actor->new(
			content => $rect,
		),
		layout => {
			x => 0,
			y => 0,
		},
	);

	if(1){#DEBUG
	my $sz = 25;
	$page_group->add_child(
		Actor->new(
			content => Rectangle->new(
				width => $sz,
				height => $sz,
				fill => Renard::Taffeta::Style::Fill->new(
					color => Renard::Taffeta::Color::Named->new( name => 'svg:red' ),
				),
			),
		),
		layout => {
			x => 0,
			y => 0,
		},
	);

	$page_group->add_child(
		Actor->new(
			content => Rectangle->new(
				width => $sz,
				height => $sz,
				fill => Renard::Taffeta::Style::Fill->new(
					color => Renard::Taffeta::Color::Named->new( name => 'svg:red' ),
				),
			),
		),
		layout => {
			x => $rect->bounds->size->width  - $sz,
			y => $rect->bounds->size->height - $sz,
		},
	);
	}

	$page_group;

}

sub composed_affine_actor {
	my (%args) = @_;

	#my $affine = Actor->new(
		#layout => Affine2D->new( transform =>
				#Renard::Taffeta::Transform::Affine2D
				#->new(
					##%args
				#)
		#),
	#);
	#my $grid = Actor->new(
		#layout => AutofillGrid->new(
			#rows => 2,
			##intergrid_space_rows => 50,
			##intergrid_space_columns => 10,
			#columns => 2,
		#),
	#);

	#$affine->add_child($grid);

	#return $affine;

	return Actor->new(
		layout => Composed->new(
			layouts => [
				All->new,
				(
				Affine2D->new( transform =>
					Renard::Taffeta::Transform::Affine2D
						->new(
							%args
						)
				),
				)x(0),
				(
				AutofillGrid->new(
					rows => 2,
					#intergrid_space_rows => 50,
					#intergrid_space_columns => 10,
					columns => 2,
				),
				)x(1),#DEBUG
			],
		)
	);
}

method tree() {
	#my $root = Actor->new(
		#layout => Composed->new(
			#layouts => [
				#All->new,
				#Affine2D->new( transform =>
					#Renard::Taffeta::Transform::Affine2D::Scaling
						#->new(
							#scale => [1.2, 1.2],
						#)
				#),
				#AutofillGrid->new(
					#rows => 4,
					#intergrid_space => 50,
					#columns => 1,
				#),
			#],
		#)
	#);
	my $top = Actor->new(
		layout => Affine2D->new( transform =>
			Renard::Taffeta::Transform::Affine2D::Scaling
				->new(
					scale => [0.2, 0.2],
				)
		),
	);
	my $root =  Actor->new(
		layout => AutofillGrid->new(
			rows => 2,
			intergrid_space => 50,
			columns => 2,
		),
	);
	$top->add_child($root);

	#my $left  = composed_affine_actor( matrix_xy => { xx => 2   , yy => 0.5 } );
	#my $right = composed_affine_actor( matrix_xy => { xx => 1   , yy => 0.9 } );
	#my $one   = composed_affine_actor( matrix_xy => { xx => 2.5 , yy => 0.7 } );
	#my $two   = composed_affine_actor( matrix_xy => { xx => 1   , yy => 1.0 } );

	my $left  = composed_affine_actor( matrix_xy => { xx => 1   , yy => 1.0 } );
	my $right = composed_affine_actor( matrix_xy => { xx => 1   , yy => 1.0 } );
	my $one   = composed_affine_actor( matrix_xy => { xx => 1.0 , yy => 1.0 } );
	my $two   = composed_affine_actor( matrix_xy => { xx => 1   , yy => 1.0 } );

	$root->add_child( $left );
	$root->add_child( $right );
	$root->add_child( $one );
	$root->add_child( $two );

	$left->add_child(  create_page_node( fill => $_ ) ) for qw(svg:blue      svg:yellow   svg:magenta);
	$right->add_child( create_page_node( fill => $_ ) ) for qw(svg:green     svg:cyan     svg:darksalmon);
	$one->add_child(   create_page_node( fill => $_ ) ) for qw(svg:firebrick svg:gold     svg:darkorchid);
	$two->add_child(   create_page_node( fill => $_ ) ) for qw(svg:honeydew  svg:seagreen svg:limegreen);

	my $states = $root->layout->update( state => Renard::Jacquard::Render::State->new );
	#use DDP; p $states, class => { expand => 'all' };
	#use DDP; p $root->layout->layouts->[1];

	return ($root, $top);
}

1;
