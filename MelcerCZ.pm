#------------------------------------------------------------------------------
package WWW::Search::MelcerCZ;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(WWW::Search);
use strict;
use warnings;

# Modules.
#use LWP::UserAgent;
use WWW::Search qw(generic_option);
use WWW::SearchResult;
#use XML::Simple;
use Readonly;

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
		'hltex' => $self->{'_query'},
	);
	if (! $response->is_success) {
		return;
	}
	my $content = $response->content;
	if ($content) {
#		foreach my $book ( @{ $ref->{'BookList'}{'BookData'} }) {
#			my $hit = WWW::SearchResult->new();
#			$hit->{'book_id'} = $book->{'book_id'};
#			$hit->{'isbn'} = $book->{'isbn'};
#			$hit->{'language'} = $book->{'Details'}{'language'} || q{};
#			$hit->{'summary'} = $book->{'Summary'} || q{};
#			$hit->{'titlelong'} = $book->{'TitleLong'} || q{};
#			$hit->{'notes'} = $book->{'Notes'} || q{};
#			$hit->title( $book->{'Title'} );
#			$hit->url( 'http://isbndb.com/search-all.html?kw=' . $book->{'isbn'} );
#			push @{$self->{'cache'}}, $hit;
#		}
		print "$content\n";
	}

	return;
}

1;
