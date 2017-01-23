use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

moon_one_test(
    meth      => \&Moonshine::Component::join_class,
    args      => [ 'component-', 'first' ],
    args_list => 1,
    expected  => 'component-first',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::join_class,
    args      => [ 'component-', 'second' ],
    args_list => 1,
    expected  => 'component-second',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::join_class,
    args      => [ 'component-', 'third' ],
    args_list => 1,
    expected  => 'component-third',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::join_class,
    args      => [ ],
    args_list => 1,
    expected  => undef,
    test      => 'SCALAR',
);

done_testing();

1;
