use strict;
use warnings;

use Test::NoWarnings;
use Test::Pod::Coverage 'tests' => 2;

# Test.
pod_coverage_ok('WWW::Search::MelcerCZ', 'WWW::Search::MelcerCZ is covered.');
