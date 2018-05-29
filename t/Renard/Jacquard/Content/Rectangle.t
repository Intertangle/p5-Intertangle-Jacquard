#!/usr/bin/env perl

use Test::Most tests => 2;
use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Content::Rectangle;
use Renard::Jacquard::Render::State;
use Renard::Taffeta::Transform::Affine2D::Scaling;

subtest "Create rectangle content" => sub {
	my $content = Renard::Jacquard::Content::Rectangle->new(
		width => 10,
		height => 20,
	);

	my $t = $content->as_taffeta;

	isa_ok $t, 'Renard::Taffeta::Graphics::Rectangle';
	is $t->width,  10;
	is $t->height, 20;
};

subtest "Scale rectangle" => sub {
	my $content = Renard::Jacquard::Content::Rectangle->new(
		width => 10,
		height => 20,
	);

	my $t = $content->as_taffeta(
		state => Renard::Jacquard::Render::State->new(
			transform => Renard::Taffeta::Transform::Affine2D::Scaling->new(
				scale => [6, 6]
			)
		)
	);

	my $tb_sz = $t->transformed_bounds->size;
	is $tb_sz->width, 60;
	is $tb_sz->height, 120;
};

done_testing;
