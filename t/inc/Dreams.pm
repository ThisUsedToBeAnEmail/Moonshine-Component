package Dreams;

use warnings;
use strict;

use Test::More;
use Params::Validate qw/:all/;

use base 'Test::Builder::Module';

use Exporter 'import';

use feature qw/switch/;
no if $] >= 5.017011, warnings => 'experimental::smartmatch';
use Scalar::Util qw/reftype blessed/;

our @EXPORT = qw/ moon_test render_me done_testing /;

our %EXPORT_TAGS = ( all => [qw/moon_test render_me done_testing/] );

my $tb = __PACKAGE__->builder;

=head1 moon_test
    
    my $args = {
        build => {
             class => 'Moonshine::Element', 
             args => {
                tag => 'p',
                text => 'hello'
             }
        }
        instructions => [
           { 
                action => 'render'
                args => {

                } 
                expected => '<p>hello</p>'
           },
           {
               action => 'text',
               expected => 'hello',
           },
        ],
    }

=cut

sub moon_test {
    my $args = shift;

    my $instructions = $args->{instructions};
    
    my $class;
    unless ( $class = $args->{class} ) {
        my $build = $args->{build};
        $class = $build->{class}->new($build->{args} // {});
    }

    for my $instruction (@{ $instructions }) {

        my $action = $instruction->{action};
        my $expected = $instruction->{expected};

        $action && $expected or diag explain $instruction and
            die 'I just burnt a hole in my home computer';

        my $test = defined $instruction->{args} 
            ? $class->$action($instruction->{args}) 
            : $class->$action;
        
        if (my $blessed = blessed $test) {
            $tb->is_eq($blessed, $expected, "$action returns Blessed - $expected");
            
            if (my $subtests = $instruction->{sub_tests}){
                diag 'Build new args for sub_tests';
                my $new_args = {
                    class => $test,
                    instructions => $subtests,
                };
                moon_test($new_args);
                diag 'Return to reality';
            }
        } else {
           given ( reftype \$test ) {
                when (/REF/) {
                    $tb->is_deeply($test, $expected, "$action IS DEEPLY - ");
                    diag explain $test;
                }
                when (/SCALAR/) {
                    $tb->is_eq($test, $expected, "$action IS SCALAR - $expected" );
                }
                default {
                  die diag explain $test;
                }
            }
        }
    }
}

=head2 render_me

    render_me(
        instance => , 
        action => '',
        args => { },
        expected => '<p>hello</p>',
    )


=cut

sub render_me {
    my %args = validate_with(
        params => \@_,
        spec => {
            instance => 1,
            action => 1,
            args => { default => { } },
            expected => { type => SCALAR },
        }
    );

    my $action = $args{action};
    return $tb->is_eq($args{instance}->$action($args{args})->render, $args{expected}, "rendered - $args{expected}");
}
