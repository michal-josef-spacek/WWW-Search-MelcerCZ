# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'WWW::Search::MelcerCZ',
	'PREREQ_PM' => {
		'Encode' => 0,
		'File::Object' => 0,
		'LWP::UserAgent' => 0,
		'Readonly' => 0,
		'Text::Iconv' => 0,
		'Web::Scraper' => 0,
		'WWW::Search' => 0,
	},
	'VERSION' => 0.02,
	'test' => {
		'TESTS' => 't/WWW::Search::MelcerCZ/*.t',
	},
);
