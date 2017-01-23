use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

moon_one_test(
    instance  => $instance,
    action => 'build_elements',
    args      => [  
        {
            class => 'not an obj, nor am action. or a tag'
        },
    ],
    args_list => 1,
    expected  => qr/no instructions to build the element:/,
    test      => 'CATCH',
);

moon_one_test(
    instance  => $instance,
    action => 'build_elements',
    args      => [  
        {
            tag => 'div',
            class => 'not an obj, nor am action. or a tag'
        },
    ],
    args_list => 1,
    expected  => 'Moonshine::Element',
    test      => 'OBJ',
);

done_testing();

1;
