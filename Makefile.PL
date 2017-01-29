use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use Module::Metadata;

WriteMakefile(
    NAME             => 'Moonshine::Component',
    AUTHOR           => q{Robert Acock <thisusedtobeanemail>},
    VERSION_FROM     => 'lib/Moonshine/Component.pm',
    ABSTRACT_FROM    => 'lib/Moonshine/Component.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Moonshine::Test' => 0,
        'Moonshine::Element' => 0,
    },
    PREREQ_PM => {
        'Moonshine::Element' => 0,
        'Params::Validate'   => 0,
        'Ref::Util'          => 0,
        'UNIVERSAL::Object'  => 0, 
        'strict'             => 0,
        'warnings'           => 0,
        'feature'            => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Moonshine-Component-*' },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/ThisUsedToBeAnEmail/Moonshine-Component.git',
                web  => 'https://github.com/ThisUsedToBeAnEmail/Moonshine-Component',
            },
        },
    },
    META_ADD => {
        provides => Module::Metadata->provides(version => '2', dir => 'lib'),
    }, 
);
