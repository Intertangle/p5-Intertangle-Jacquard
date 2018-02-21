#!/usr/bin/env perl

use Test::Most tests => 2;

use lib 't/lib';

use Renard::Incunabula::Common::Setup;
use Renard::Jacquard::Actor;
use Renard::Yarn::Graphene;

subtest "Create an actor" => sub {
	new_ok 'Renard::Jacquard::Actor';
};

subtest "Create an actor with children" => sub {
	my $actor = Renard::Jacquard::Actor->new();
	my @children = map {
		Renard::Jacquard::Actor->new()
	} 0..3;

	$actor->add_child( $_ ) for @children;

	is $actor->number_of_children, scalar @children, 'have the right number of child nodes';

	is $actor->children->[1], $children[1], 'same actor at index 1';
};

done_testing;
