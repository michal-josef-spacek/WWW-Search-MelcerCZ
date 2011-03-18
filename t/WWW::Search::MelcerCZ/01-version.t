# Modules.
use WWW::Search::MelcerCZ;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($WWW::Search::MelcerCZ::VERSION, '0.02');
