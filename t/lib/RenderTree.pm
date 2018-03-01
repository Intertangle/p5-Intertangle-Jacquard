package RenderTree;

use Renard::Incunabula::Common::Setup;
use Path::Tiny;

method render_to_svg( $container, $path ) {
	require SVG;

	my $positions = $container->layout->update;

	SVG->import;
	my $svg = SVG->new( width => 100, height => 100 );
	use Renard::Taffeta::Graphics::Rectangle;
	use Renard::Taffeta::Style::Fill;
	use Renard::Taffeta::Style::Stroke;
	use Renard::Taffeta::Color::Named;
	my @actors = @{ $container->children };
	for my $actor (@actors) {
		my $gfx_rect = Renard::Taffeta::Graphics::Rectangle->new(
			position => $positions->{$actor},
			width => $actor->bounds->width, height => $actor->bounds->height,
			fill => Renard::Taffeta::Style::Fill->new(
				color => Renard::Taffeta::Color::Named->new( name => 'svg:red' ),
			),
			stroke => Renard::Taffeta::Style::Stroke->new(
				color => Renard::Taffeta::Color::Named->new( name => 'svg:blue' ),
			),
		);
		$gfx_rect->render_svg( $svg )
	}

	$path->spew_utf8($svg->xmlify);
}

1;
