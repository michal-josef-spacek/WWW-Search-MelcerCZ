use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::NoWarnings;

BEGIN {

	# Test.
	use_ok('WWW::Search::MelcerCZ');
}

# Test.
require_ok('WWW::Search::MelcerCZ');
