package WWW::Search::MelcerCZ;

use base qw(WWW::Search);
use strict;
use warnings;

use Encode qw(decode_utf8 encode_utf8);
use Perl6::Slurp qw(slurp);
use LWP::UserAgent;
use Readonly;
use Text::Iconv;
use WWW::Search::MelcerCZ::Utils qw(scraper_v20100411);

# Constants.
Readonly::Scalar our $MAINTAINER => 'Michal Josef Spacek <skim@cpan.org>';
Readonly::Scalar my $MELCER_CZ => 'http://melcer.cz/';
Readonly::Scalar my $MELCER_CZ_ACTION1 => 'index.php?akc=hledani&s=0&kos=0'.
	'&hltext=$hltex&kateg=';

our $VERSION = 0.02;

# Setup.
sub _native_setup_search {
	my ($self, $query, $options) = @_;
	$self->{'_def'} = scraper_v20100411();
	$self->{'_offset'} = 0;
	$self->{'_query'} = $query;
	return 1;
}

# Get data.
sub _native_retrieve_some {
	my $self = shift;

	if (defined $self->{search_from_file}) {
		my $content = slurp($self->{search_from_file});
		$self->_process_content($content);
	} else {
		# Query.
		my $i = Text::Iconv->new('utf-8', 'windows-1250');
		my $query = $i->convert(decode_utf8($self->{'_query'}));

		# Get content.
		my $ua = LWP::UserAgent->new(
			'agent' => "WWW::Search::MelcerCZ/$VERSION",
		);
		my $response = $ua->post($MELCER_CZ.$MELCER_CZ_ACTION1,
			'Content' => {
				'hltex' => $query,
				'hledani' => 'Hledat',
			},
		);

		# Process.
		if ($response->is_success) {
			$self->_process_content($response->content);
		}
	}

	return;
}

sub _process_content {
	my ($self, $content) = @_;

	# Get books structure.
	my $books_hr = $self->{'_def'}->scrape($content);

	# Iconv.
	if (! $self->{'_iconv'} && $books_hr->{'encoding'}) {
		$self->{'_iconv'} = Text::Iconv->new(
			$books_hr->{'encoding'}, 'utf-8');
	}

	# Process each book.
	foreach my $book_hr (@{$books_hr->{'books'}}) {
		_fix_url($book_hr, 'cover_url');
		_fix_url($book_hr, 'url');
		push @{$self->{'cache'}}, $self->_process($book_hr);
	}

	# Next url.
	_fix_url($books_hr, 'next_url');
	$self->next_url($books_hr->{'next_url'});

	return;
}

# Fix URL to absolute path.
sub _fix_url {
	my ($book_hr, $url) = @_;
	if (exists $book_hr->{$url}) {
		$book_hr->{$url} = $MELCER_CZ.$book_hr->{$url};
	}
	return;
}

# Process each parameter of structure.
sub _process {
	my ($self, $book_hr) = @_;
	$self->_process_one($book_hr, 'author');
	$self->_process_one($book_hr, 'info');
	$self->_process_one($book_hr, 'publisher');
	$self->_process_one($book_hr, 'price');
	$self->_process_one($book_hr, 'title');
	return $book_hr;
}

# Process string to right output:
# - Encode to utf8.
# - Remove trailing whitespace.
sub _process_one {
	my ($self, $book_hr, $key) = @_;

	# No value.
	if (! exists $book_hr->{$key}) {
		return;
	}

	# Encode to utf8.
	if ($self->{'_iconv'}) {
		$book_hr->{$key} = $self->{'_iconv'}->convert(
			$book_hr->{$key});
	}

	# Encode to perl internal form.
	$book_hr->{$key} = decode_utf8($book_hr->{$key});

	# Remove trailing whitespace.
	$book_hr->{$key} =~ s/^\s+//gms;
	$book_hr->{$key} =~ s/\s+$//gms;

	# Encode to octets for output.
	$book_hr->{$key} = encode_utf8($book_hr->{$key});

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

WWW::Search::MelcerCZ - Class for searching http://melcer.cz .

=head1 SYNOPSIS

 use WWW::Search::MelcerCZ;
 my $obj = WWW::Search->new('MelcerCZ');
 $obj->native_query($query);
 my $maintainer = $obj->maintainer; 
 my $res_hr = $obj->next_result;
 my $version = $obj->version;

=head1 METHODS

=over 8

=item C<native_setup_search($query)>

 Setup.

=item C<native_retrieve_some()>

 Get data.

=back

=head1 EXAMPLE

 use strict;
 use warnings;

 use Data::Printer;
 use WWW::Search::MelcerCZ;

 # Arguments.
 if (@ARGV < 1) {
         print STDERR "Usage: $0 match\n";
         exit 1;
 }
 my $match = $ARGV[0];

 # Object.
 my $obj = WWW::Search->new('MelcerCZ');
 $obj->maximum_to_retrieve(1);

 # Search.
 $obj->native_query($match);
 while (my $result_hr = $obj->next_result) {
        p $result_hr;
 }

 # Output:
 # Usage: /tmp/1Ytv23doz5 match

 # Output with 'Čapek' argument:
 # \ {
 #     author      "Čapek Karel",
 #     cover_url   "http://melcer.cz//img/books/images_big/142829.jpg",
 #     info        "obálky a typo Zdenek Seydl, 179 + 156 stran, původní brože 8°, stav velmi dobrý",
 #     price       "97.00 Kč",
 #     publisher   "Československý spisovatel",
 #     title       "Povídky z jedné a druhé kapsy (2 svazky)",
 #     url         "http://melcer.cz//index.php?akc=detail&idvyrb=53259&hltex=%C8apek&autor=&nazev=&odroku=&doroku=&vydavatel=",
 #     year        1967
 # }

=head1 DEPENDENCIES

L<Encode>,
L<LWP::UserAgent>,
L<Readonly>,
L<Text::Iconv>,
L<Web::Scraper>,
L<WWW::Search>.

=head1 SEE ALSO

=over

=item L<WWW::Search>

Virtual base class for WWW searches

=item L<Task::WWW::Search::Antiquarian::Czech>

Install the WWW::Search modules for Czech antiquarian bookstores.

=back

=head1 REPOSITORY

L<https://github.com/tupinek/WWW-Search-MelcerCZ>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

 © Michal Josef Špaček 2010-2020
 BSD 2-Clause License

=head1 VERSION

0.02

=cut
