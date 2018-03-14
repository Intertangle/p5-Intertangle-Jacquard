#!/usr/bin/env perl

use Test::Most tests => 1;
use Renard::Incunabula::Common::Setup;
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

fun create_page_node( :$fill = 'svg:black' ) {
	my $page_group = Actor->new(
		layout => Fixed->new
	);

	$page_group->add_child(
		Actor->new(
			content => Rectangle->new(
				width  => 100,
				height => 200,
				fill   => Renard::Taffeta::Style::Fill->new(
					color => Renard::Taffeta::Color::Named->new( name => $fill ),
				),
				stroke => Renard::Taffeta::Style::Stroke->new(
					color => Renard::Taffeta::Color::Named->new( name => 'svg:blue' ),
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
				width => 25,
				height => 25,
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
				width => 25,
				height => 25,
				fill => Renard::Taffeta::Style::Fill->new(
					color => Renard::Taffeta::Color::Named->new( name => 'svg:red' ),
				),
			),
		),
		layout => {
			x => 100 - 25,
			y => 200 - 25,
		},
	);

	$page_group;
}

sub composed_affine_actor {
	my (%args) = @_;
	return Actor->new(
		layout => Composed->new(
			layouts => [
				All->new,
				Affine2D->new( transform =>
					Renard::Taffeta::Transform::Affine2D
						->new(
							%args
						)
				),
				AutofillGrid->new(
					rows => 2,
					columns => 2,
				),
			],
		)
	);
}

subtest "What is the point?" => sub {
	use Carp::Always;
	my $root = Actor->new(
		layout => Composed->new(
			layouts => [
				All->new,
				AutofillGrid->new(
					rows => 2,
					columns => 2,
				),
			],
		)
	);

	my $left  = composed_affine_actor( matrix_xy => { xx => 2   , yy => 0.5 } );
	my $right = composed_affine_actor( matrix_xy => { xx => 1   , yy => 0.8 } );
	my $one   = composed_affine_actor( matrix_xy => { xx => 2.5 , yy => 1.0 } );
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

	use Renard::Jacquard::Render::GenerateTree;

	Renard::Jacquard::Render::GenerateTree
		->render_tree_to_svg(
			Renard::Jacquard::Render::GenerateTree->get_render_tree(
				root => $root ),
			'point.svg' );

	pass;
};

done_testing;
