use strict;
use warnings;

use WWW::Search::MelcerCZ;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($WWW::Search::MelcerCZ::VERSION, 0.02, 'Version.');
