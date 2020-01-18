use strict;
use warnings;

use File::Object;
use WWW::Search::MelcerCZ;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test data directory.
my $test_dir = File::Object->new->up->dir('data');

sub test {
	my ($html_file, $query) = @_;
	my $search = WWW::Search->new('MelcerCZ',
		'search_from_file' => $test_dir->file($html_file)->s,
	);
	$search->maximum_to_retrieve(1);
	my $ret = $search->native_query($query);
	my $first_result_hr = $search->next_result;
	return $first_result_hr;
}

# Test.
my $first_result_hr = test('melcer_cz-20100411-Bass.html', 'Bass');
is_deeply(
	$first_result_hr,
	{
		'author' => 'Bass Eduard',
		'cover_url' => 'http://melcer.cz/img/books/images_big/57480.jpg',
		'info' => 'obálka Josef Čapek, 165 stran, původní brož 8°, stav velmi dobrý, obálka se stopami opotřebení',
		'price' => '200.00 Kč',
		'publisher' => 'Fr. Borový, Praha',
		'title' => 'Šest děvčat Williamsových',
		'url' => 'http://melcer.cz/sindex.php?akc=detail&idvyrb=12358&hltex=Bass&autor=&nazev=&odroku=&doroku=&vydavatel=',
		'year' => '1930',
	},
	'Parse html page file.',
);
