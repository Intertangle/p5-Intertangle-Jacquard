use Renard::Incunabula::Common::Setup;
package Intertangle::Jacquard::Actor::Role::DataPrinter;
# ABSTRACT: Role to do Data::Printer things

use Mu::Role;

requires '_data_printer_internal';

sub _data_printer {
	my ($self, $prop) = @_;

	use Module::Load;
	BEGIN {
		eval {
			autoload Data::Printer::Filter;
			autoload Term::ANSIColor;
		};
	}

	my $text = '';

	$text .= $prop->{colored} ? "(@{[colored(['green'], ref($self))]}) " : "(@{[ ref($self) ]}) ";
	$text .= Data::Printer::np($self->_data_printer_internal, %$prop, );

	$text;
}

1;
