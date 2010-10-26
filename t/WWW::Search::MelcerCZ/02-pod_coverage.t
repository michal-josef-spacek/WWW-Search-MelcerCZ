# Modules.
use Test::Pod::Coverage 'tests' => 1;

print "Testing: Pod coverage.\n";
pod_coverage_ok('WWW::Search::MelcerCZ', 'WWW::Search::MelcerCZ is covered.');
