# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('WWW::Search::MelcerCZ');
}
require_ok('WWW::Search::MelcerCZ');
