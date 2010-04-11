#------------------------------------------------------------------------------
package WWW::Search::MelcerCZ;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(WWW::Search);
use strict;
use warnings;

# Modules.
use LWP::UserAgent;
use Readonly;
use Web::Scraper;
use WWW::Search qw(generic_option);

# Constants.
Readonly::Scalar my $MELCER_CZ_BASE_URL => 'http://www.melcer.cz/sindex.php'.
	'?akc=hledani&s=0&kos=0&hltext=$hltex&kateg=';

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub native_setup_search {
#------------------------------------------------------------------------------
# TODO

	my ($self, $query) = @_;
	$self->{'_offset'} = 0;
	$self->{'_query'} = $query;
	$self->{'_def'} = scraper {
		process '//td[@height="330"]/node()[3]', 'records' => 'RAW';
		process '//td[@height="330"]/table[@width="560"]', 'books[]'
			=> scraper {

			process '//tr/td/font/a', 'title' => 'RAW';
			process '//tr/td[@width="136"]/node()[3]',
				'price' => 'RAW';
			process '//tr[2]/td/font/strong', 'author' => 'RAW';
			process '//tr[3]/td/font/div', 'info' => 'RAW';
			process '//tr[4]/td/div/a', 'url' => '@href';
			process '//tr[5]/td[1]/font[2]', 'publisher' => 'RAW';
			process '//tr[5]/td[2]/font[2]', 'year' => 'RAW';
			return;
		};
		return;
	};
	return 1;
}

#------------------------------------------------------------------------------
sub native_retrieve_some {
#------------------------------------------------------------------------------
# TODO

	my $self = shift;

	# TODO Escape query.

	# Get content.
	my $ua = LWP::UserAgent->new(
		'agent' => "WWW::Search::MelcerCZ/$VERSION",
	);
	my $response = $ua->post($MELCER_CZ_BASE_URL,
		'Content' => {
			'hltex' => $self->{'_query'},
			'hledani' => 'Hledat',
		},
	);

	# Process.
	if ($response->is_success) {
		my $content = $response->content;
		my $book_hr = $self->{'_def'}->scrape($content);
		foreach my $book_hr (@{$book_hr->{'books'}}) {
			push @{$self->{'cache'}}, $book_hr;
		}
	}

	return;
}

1;
