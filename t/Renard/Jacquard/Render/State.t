#!/usr/bin/env perl

use Test::Most tests => 1;
use Modern::Perl;
use Renard::Jacquard::Render::State;
use Renard::Taffeta::Transform::Affine2D::Translation;
use Renard::Taffeta::Transform::Affine2D::Scaling;

subtest "Composition of transforms" => sub {
	subtest "Identity matrix" => sub {
		my $state = Renard::Jacquard::Render::State->new;
		ok $state->transform->is_identity;
	};

	subtest "Coordinate system transform only" => sub {
		my $state = Renard::Jacquard::Render::State->new(
			coordinate_system_transform => Renard::Taffeta::Transform::Affine2D::Translation->new(
				translate => [2, 3],
			)
		);

		is $state->transform->apply_to_point([0,0]), [2, 3];
		is $state->transform->apply_to_point([0,1]), [2, 4];
		is $state->transform->apply_to_point([1,0]), [3, 3];
		is $state->transform->apply_to_point([1,1]), [3, 4];
	};

	subtest "Geometry transform only" => sub {
		my $state = Renard::Jacquard::Render::State->new(
			geometry_transform => Renard::Taffeta::Transform::Affine2D::Scaling->new(
				scale => [2, 5],
			)
		);

		is $state->transform->apply_to_point([0,0]), [0, 0];
		is $state->transform->apply_to_point([1,1]), [2, 5];
	};

	subtest "Coordinate system and geometry transform" => sub {
		my $state = Renard::Jacquard::Render::State->new(
			coordinate_system_transform => Renard::Taffeta::Transform::Affine2D::Translation->new(
				translate => [2, 3],
			),
			geometry_transform => Renard::Taffeta::Transform::Affine2D::Scaling->new(
				scale => [2, 5],
			)
		);

		is $state->transform->apply_to_point([0,0]), [2, 3];
		is $state->transform->apply_to_point([1,0]), [2 + 2*1, 3 + 5*0];
		is $state->transform->apply_to_point([0,1]), [2 + 2*0, 3 + 5*1];
		is $state->transform->apply_to_point([1,1]), [2 + 2*1, 3 + 5*1];
		is $state->transform->apply_to_point([3,1]), [2 + 2*3, 3 + 5*1];
	};
};

done_testing;
