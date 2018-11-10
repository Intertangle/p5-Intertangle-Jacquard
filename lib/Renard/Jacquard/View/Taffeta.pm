use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::View::Taffeta;
# ABSTRACT: A Taffeta view

use Moo;
use Renard::Yarn::Types qw(Matrix);
use Renard::Incunabula::Common::Types qw(InstanceOf);

has camera_matrix => (
	is => 'ro',
	default => method() {
		my $m = Renard::Yarn::Graphene::Matrix->new;
		$m->init_identity;
		$m;
	},
	isa => Matrix,
);

has viewport => (
	is => 'ro',
	isa => InstanceOf['Renard::Taffeta::Graphics'],
);

1;
