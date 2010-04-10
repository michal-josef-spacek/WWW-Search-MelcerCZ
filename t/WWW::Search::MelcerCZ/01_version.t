# Modules.
use WWW::Search::MelcerCZ;
use Test::More 'tests' => 1;

print "Testing: version.\n";
is($WWW::Search::MelcerCZ::VERSION, '0.01');
