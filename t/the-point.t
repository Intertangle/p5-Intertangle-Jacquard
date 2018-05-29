#!/usr/bin/env perl

use Test::Most tests => 1;
use Test::Needs qw(SVG Data::Printer);
use lib 't/lib';

use Renard::Incunabula::Common::Setup;
use Path::Tiny;
use ThePoint;

subtest "What is the point?" => sub {
	use Carp::Always;
	my ($root, $top) = ThePoint->tree;

	use Renard::Jacquard::Render::GenerateTree;

	my $tree = Renard::Jacquard::Render::GenerateTree->get_render_tree(
				root => $root );

	my $file = Path::Tiny->tempfile;
	Renard::Jacquard::Render::GenerateTree
		->render_tree_to_svg(
			Renard::Jacquard::Render::GenerateTree->get_render_tree(
				root => $top ),
			$file );

	#use DDP; p $tree, class => { expand => 'all' };

	pass;
};

done_testing;
