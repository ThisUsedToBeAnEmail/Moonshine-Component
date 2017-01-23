use Dreams qw/:all/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new( {} );

package Test::First;

our @ISA; { @ISA = 'Moonshine::Component' };

BEGIN { 
    my %modifer_spec = map { $_ => 0 } qw/switch switch_base/;
    %HAS = (
        %Moonshine::Component::HAS,
        modifier_spec => sub { \%modifer_spec }
    );
}

sub modify {
    my $self = shift;
    my ($base_args, $build_args, $modify_args) = @_;
    if ($modify_args->{switch}) {
        my $class = sprintf '%s', $self->join_class($modify_args->{switch_base}, $modify_args->{switch});
        $base_args->{class} = $self->prepend_str($class, $base_args->{class});
    }
    return $base_args, $build_args, $modify_args;
}

sub glyphicon {
    my $self = shift;
    my ( $base_args, $build_args ) = $self->validate_build(
        {
            params => $_[0] // {},
            spec => {
                switch      => 1,
                switch_base => { default => 'glyphicon glyphicon-' },
                aria_hidden => { default => 'true' },
            }
        }
    );
    return $self->span($base_args);
}

package main;

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

moon_one_test(
    instance  => $instance,
    action => 'build_elements',
    args      => [  
        {
            action => 'nope',
            class => 'not an obj, nor am action. or a tag'
        },
    ],
    args_list => 1,
    expected  => qr/cannot find action - nope/,
    test      => 'CATCH',
);

my $test_instance = Test::First->new({});

moon_one_test(
    instance  => $test_instance,
    action => 'build_elements',
    args      => [  
        {
            action => 'glyphicon',
            switch => 'search',
        },
    ],
    args_list => 1,
    expected  => '<span class="glyphicon glyphicon-search" aria-hidden="true"></span>',
    test      => 'RENDER',
);

my $test_element = Moonshine::Element->new({ tag => 'span', class => 'glyphicon glyphicon-search', aria_hidden => 'true' });

moon_one_test(
    instance  => $instance,
    action => 'build_elements',
    args      => [  
        $test_element
    ],
    args_list => 1,
    expected  => '<span class="glyphicon glyphicon-search" aria-hidden="true"></span>',
    test      => 'RENDER',
);

done_testing();

1;
