package WWW::Search::MelcerCZ::Utils;

use base qw(Exporter);
use strict;
use warnings;

use Web::Scraper;

# Constants.
Readonly::Array our @EXPORT_OK => qw(scraper_v20100411);

our $VERSION = 0.02;

sub scraper_v20100411 {
	return scraper {
		process '//meta[@http-equiv="Content-Type"]', 'encoding' => [
			'@content',
			\&_get_encoding,
		];
		process '//table[@width="100"]/tr/td[5]/a',
			'next_url' => '@href';
		process '//td[@height="330"]/node()[3]', 'records' => 'RAW';
		process '//td[@height="330"]/table[@width="560"]', 'books[]'
			=> scraper {

			process '//tr/td/font/a', 'title' => 'RAW',
				'url' => '@href';
			process '//tr/td[@width="136"]/font[2]',
				'price' => 'RAW';
			process '//tr[2]/td/font/strong', 'author' => 'RAW';
			process '//tr[3]/td/font/div', 'info' => 'RAW';
			process '//tr[4]/td/div/a', 'cover_url' => '@href';
			process '//tr[5]/td[1]/font[2]', 'publisher' => 'RAW';
			process '//tr[5]/td[2]/font[2]', 'year' => 'RAW';
			return;
		};
		return;
	};
}

# Get enconding from Content-Type string.
sub _get_encoding {
	my $content_type = shift;
	if ($content_type =~ m/.*charset=(.*)$/ms) {
		return $1;
	} else {
		return;
	}
}

1;

__END__
