# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Debug message.
print "Testing: Pod coverage.\n";

# Test.
pod_coverage_ok('WWW::Search::MelcerCZ', 'WWW::Search::MelcerCZ is covered.');
