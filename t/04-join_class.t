use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

moon_one_test(
    instance  => $instance,
    action    => 'join_class', 
    args      => [ 'component-', 'first' ],
    args_list => 1,
    expected  => 'component-first',
    test      => 'SCALAR',
);

moon_one_test(
    instance  => $instance,
    action    => 'join_class',
    args      => [ 'component-' ],
    args_list => 1,
    expected  => undef,
    test      => 'SCALAR',
);

moon_one_test(
    instance  => $instance,
    action    => 'join_class',
    args      => [ ],
    args_list => 1,
    expected  => undef,
    test      => 'SCALAR',
);

done_testing();

1;
