use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Class for searching http://melcer.cz .';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.01;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'WWW-Search-MelcerCZ';
readme_from 'MelcerCZ.pm';
recursive_author_tests('xt');
requires 'Encode' => 0,
requires 'LWP::UserAgent' => 0;
requires 'Readonly' => 0;
requires 'Text::Iconv' => 0;
requires 'Web::Scraper' => 0;
requires 'WWW::Search' => 0;
requires 'perl' => '5.6.2';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=WWW-Search-MelcerCZ';
resources 'homepage' => 'https://github.com/tupinek/WWW-Search-MelcerCZ';
resources 'repository' => 'git://github.com/tupinek/WWW-Search-MelcerCZ';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
