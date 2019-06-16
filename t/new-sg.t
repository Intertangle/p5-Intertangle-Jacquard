#!/usr/bin/env perl

use Test::Most tests => 2;

use Renard::Incunabula::Common::Setup;

use aliased 'Renard::Jacquard::Actor::Applicator';

use aliased 'Renard::Jacquard::Actor::Attribute::Transform::Affine2D';
use aliased 'Renard::Jacquard::Actor::Attribute::Group';

use aliased 'Renard::Taffeta::Transform::Affine2D::Translation';

use aliased 'Renard::Jacquard::Actor::Taffeta::Graphics';

subtest "Affine2D as tree" => fun() {
	my $tree =
		Applicator->new(
			attribute_graph =>
				Affine2D->new( transform => Translation->new( translate => [ 1, 1 ] ) ),
			scene_graph =>
				Applicator->new(
					attribute_graph =>
						Affine2D->new( transform => Translation->new( translate => [ 2, 2 ] ) ),
					scene_graph => Applicator->new(
						attribute_graph =>
							Affine2D->new( transform => Translation->new( translate => [ 3, 3 ] ) ),
						scene_graph =>
							Graphics->new,
					),
				),
		);
	pass;
};

subtest "Affine2D as group" => fun() {
	my $tree =
		Applicator->new(
			attribute_graph => Group->new(
				children => [
					Affine2D->new( transform => Translation->new( translate => [ 1, 1 ] ) ),
					Affine2D->new( transform => Translation->new( translate => [ 2, 2 ] ) ),
					Affine2D->new( transform => Translation->new( translate => [ 3, 3 ] ) ),
				],
			),
			scene_graph => Graphics->new,
		);
	pass;
};

done_testing;
