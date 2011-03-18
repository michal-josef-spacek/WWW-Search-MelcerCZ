# Modules.
use Test::More 'tests' => 2;

BEGIN {
	# Debug message.
	print "Usage tests.\n";

	# Test.
	use_ok('WWW::Search::MelcerCZ');
}

# Test.
require_ok('WWW::Search::MelcerCZ');
