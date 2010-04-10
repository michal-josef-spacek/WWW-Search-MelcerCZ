# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'WWW::Search::MelcerCZ',
	'PREREQ_PM' => {
		'File::Object' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/WWW::Search::MelcerCZ/*.t',
	},
);
