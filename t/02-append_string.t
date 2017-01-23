use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

moon_one_test(
    meth      => \&Moonshine::Component::append_str,
    args      => [ 'okay', 'first' ],
    args_list => 1,
    expected  => 'okay first',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::append_str,
    args      => [ 'okay', 'second' ],
    args_list => 1,
    expected  => 'okay second',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::append_str,
    args      => [ 'okay', 'third' ],
    args_list => 1,
    expected  => 'okay third',
    test      => 'SCALAR',
);

done_testing();

1;
