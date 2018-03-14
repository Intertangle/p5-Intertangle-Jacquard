#!/usr/bin/env perl

use Test::Most tests => 1;
use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Content::Rectangle;

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

done_testing;
