use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Role::Graphics::Taffeta;
# ABSTRACT: A role actors created from Taffeta classes

use Moo::Role;
use Renard::Incunabula::Common::Types qw(HashRef InstanceOf Bool ClassName);
use MooX::ClassAttribute;
use Renard::Jacquard::Render::State;

class_has taffeta_class => (
	is => 'ro',
	isa => ClassName,
);

has _delegate_args => (
	is => 'ro',
	isa => HashRef,
);

=method bounds

Returns the bounds of the content.

=cut
method bounds( $state = Renard::Jacquard::Render::State->new ) :ReturnType(InstanceOf['Renard::Yarn::Graphene::Rect']) {
	my $transformed_rect = $self->taffeta_class->new(
		transform => $state->transform,
		%{ $self->_delegate_args },
	)->transformed_bounds;

	$transformed_rect;
}

around BUILDARGS => fun( $orig, $class, %args ) {
	my $taffeta_class = $class->taffeta_class;
	my %taffeta_attr = map { ( $_->name => 1 ) }
		grep { $_->has_init_arg &&  ! $_->is_lazy }
		$taffeta_class->meta->get_all_attributes;

	my %taffeta_args;
	for my $attr (keys %taffeta_attr) {
		if( exists $args{$attr} ) {
			$taffeta_args{ $attr } = delete $args{$attr};
		}
	}

	$args{_delegate_args} = \%taffeta_args;

	return $class->$orig(%args);
};

=method as_taffeta

Returns a Taffeta graphics object for the content.

=cut
method as_taffeta(
	(InstanceOf['Renard::Jacquard::Render::State']) :$state = Renard::Jacquard::Render::State->new,
	:$taffeta_args = {} ) {
	use Clone qw(clone);
	my %extra_args = (
		transform => $state->transform,
	);

	my $args = clone $self->_delegate_args;

	$self->taffeta_class->new(
		%$args,
		%extra_args,
		%$taffeta_args,
	);
}

1;
