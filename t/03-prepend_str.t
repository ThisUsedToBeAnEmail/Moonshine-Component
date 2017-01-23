use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

moon_one_test(
    meth      => \&Moonshine::Component::prepend_str,
    args      => [ 'okay', 'first' ],
    args_list => 1,
    expected  => 'first okay',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::prepend_str,
    args      => [ 'okay', 'second' ],
    args_list => 1,
    expected  => 'second okay',
    test      => 'SCALAR',
);

moon_one_test(
    meth      => \&Moonshine::Component::prepend_str,
    args      => [ 'okay', 'third' ],
    args_list => 1,
    expected  => 'third okay',
    test      => 'SCALAR',
);

done_testing();

1;
