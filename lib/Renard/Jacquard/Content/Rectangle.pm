use Renard::Incunabula::Common::Setup;
package Renard::Jacquard::Content::Rectangle;
# ABSTRACT: Rectangle content

use Mu;
use MooX::ClassAttribute;
use Renard::Incunabula::Common::Types qw(HashRef InstanceOf Bool);
use Renard::Taffeta::Graphics::Rectangle;

class_has taffeta_class => (
	is => 'ro',
	default => sub {
		'Renard::Taffeta::Graphics::Rectangle',
	},
);

has _needs_position => (
	is => 'ro',
	isa => Bool,
);

has _delegate_args => (
	is => 'ro',
	isa => HashRef,
);

method bounds( $state ) :ReturnType(InstanceOf['Renard::Yarn::Graphene::Rect']) {
	my $at_origin = $self->taffeta_class->new(
		# use origin as position
		position => Renard::Yarn::Graphene::Point->new(
			x => 0,
			y => 0,
		),
		%{ $self->_delegate_args },
	);
	use DDP; p $state->transform->matrix;

	my $transformed_rect = $state->transform->matrix->transform_bounds($at_origin->bounds);
	use DDP; p $transformed_rect;

	$transformed_rect;
}

around BUILDARGS => fun( $orig, $class, %args ) {
	my $taffeta_class = $class->taffeta_class;
	my %taffeta_attr = map { ( $_->name => 1 ) }
		grep { $_->has_init_arg &&  ! $_->is_lazy }
		$taffeta_class->meta->get_all_attributes;

	if( $taffeta_class->meta->does_role('Renard::Taffeta::Graphics::Role::WithPosition') ) {
		delete $taffeta_attr{position};
		$args{_needs_position} = 1;
		if( exists $args{position} ) {
			warn "Can not use position for content";
			delete $args{position};
		}
	}

	my %taffeta_args;
	for my $attr (keys %taffeta_attr) {
		if( exists $args{$attr} ) {
			$taffeta_args{ $attr } = delete $args{$attr};
		}
	}

	$args{_delegate_args} = \%taffeta_args;

	return $class->$orig(%args);
};

method as_taffeta( (InstanceOf['GraphicsState']) $state, $position = ) {
	use Clone qw(clone);
	my %extra_args;

	if( $self->_needs_position ) {
		$extra_args{position} = $position;
	}

	my $args = clone $self->_delegate_args;
	$args->{height} = (
		$state->transform->matrix * Renard::Yarn::Graphene::Point->new( x => 0, y => $args->{height} )
	)->y;
	$args->{width} = (
		$state->transform->matrix * Renard::Yarn::Graphene::Point->new( x => => $args->{width}, y => 0 )
	)->x;

	$self->taffeta_class->new(
		%$args,
		%extra_args
	);
}

1;
