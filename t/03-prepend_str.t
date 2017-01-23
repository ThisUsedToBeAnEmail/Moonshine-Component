use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

moon_one_test(
    instance  => $instance,
    action    => 'prepend_str',
    args      => [ 'okay', 'first' ],
    args_list => 1,
    expected  => 'first okay',
    test      => 'SCALAR',
);

moon_one_test(
    instance  => $instance,
    action    => 'prepend_str',
    args      => [ 'okay' ],
    args_list => 1,
    expected  => 'okay',
    test      => 'SCALAR',
);

moon_one_test(
    instance  => $instance,
    action    => 'prepend_str',
    args      => [ ],
    args_list => 1,
    expected  => undef,
    test      => 'SCALAR',
);

done_testing();

1;
