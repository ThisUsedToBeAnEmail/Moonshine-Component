package Dreams;

use warnings;
use strict;

use Test::More;
use Params::Validate qw/:all/;
use B qw/svref_2object/;
use Scalar::Util qw/blessed/;
use base 'Test::Builder::Module';
use Exporter 'import';

use feature qw/switch/;
no if $] >= 5.017011, warnings => 'experimental::smartmatch';
use Scalar::Util qw/reftype blessed/;

our @EXPORT = qw/ moon_test render_me moon_one_test done_testing/;

our %EXPORT_TAGS =
  ( all => [qw/moon_test render_me moon_one_test done_testing/] );

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
        $class = $build->{class}->new( $build->{args} // {} );
    }

    for my $instruction ( @{$instructions} ) {

        my $action   = $instruction->{action};
        my $expected = $instruction->{expected};

        $action && $expected
          or diag explain $instruction;

        my $test =
          defined $instruction->{args}
          ? $class->$action( $instruction->{args} )
          : $class->$action;

        if ( my $blessed = blessed $test) {
            $tb->is_eq( $blessed, $expected,
                "$action returns Blessed - $expected" );

            if ( my $subtests = $instruction->{sub_tests} ) {
                diag 'Build new args for sub_tests';
                my $new_args = {
                    class        => $test,
                    instructions => $subtests,
                };
                moon_test($new_args);
                diag 'Return to reality';
            }
        }
        else {
            given ( reftype \$test ) {
                when (/REF/) {
                    $tb->is_deeply( $test, $expected, "$action IS DEEPLY - " );
                    diag explain $test;
                }
                when (/SCALAR/) {
                    $tb->is_eq( $test, $expected,
                        "$action IS SCALAR - $expected" );
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
        spec   => {
            instance => 1,
            action   => 1,
            args     => { default => {} },
            expected => { type => SCALAR },
        }
    );

    my $action = $args{action};
    return $tb->is_eq( $args{instance}->$action( $args{args} )->render,
        $args{expected}, "rendered - $args{expected}" );
}

sub moon_one_test {
    my %instruction = validate_with(
        params => \@_,
        spec   => {
            instance  => 0,
            meth      => 0,
            action    => 0,
            args      => { default => {} },
            args_list => 0,
            test      => 1,
            expected  => 1,
        }
    );

    my @expected = $instruction{expected};

    my @test;
    my $test_name;

    if ($instruction{test} eq 'CATCH') {
        eval { _prepare_test(%instruction) };
        @test = $@;
    }
    else {
        @test = _prepare_test(%instruction);
        $test_name = shift @test;
    }

    given ( $instruction{test} ) {
        when (/REF/) {
            return is_deeply( $test[0], $expected[0], "$test_name IS DEEP" );
        }
        when (/SCALAR/) {
            my $txt = $expected[0] // 'undef';
            return $tb->is_eq( $test[0], $expected[0],
                "$test_name IS SCALAR - $txt" );
        }
        when (/HASH/) {
            return is_deeply( {@test}, {@expected}, "$test_name IS DEEP" );
        }
        when (/ARRAY/) {
            return is_deeply( \@test, \@expected, "$test_name IS DEEP" )
        }
        when (/OBJ/) {
            return $tb->is_eq(
                blessed $test[0][0],
                $expected[0],
                "$test_name returns Blessed - $expected[0]"
            );
        }
        when (/CATCH/) {
            return $tb->like(
                $test[0],
                $expected[0],
                "catches something like - $expected[0]",
            );
        }
        default {
            die diag explain \@test;
        }
    }
}

sub _prepare_test {
    my %instruction = @_;

    my $test_name;
    if (my $action = $instruction{action}) {
        $test_name = $action;
        return defined $instruction{args_list}
          ? ($test_name, $instruction{instance}->$action(@{ $instruction{args} }))
          : ($test_name, $instruction{instance}->$action( $instruction{args} ));
    }
    elsif(my $meth = $instruction{meth}) {
        my $cv = svref_2object($meth);
        my $gv = $cv->GV;
        my $test_name = $gv->NAME;
        return defined $instruction{args_list}
          ? ($test_name, $meth->( @{ $instruction{args} } ))
          : ($test_name, $meth->( $instruction{args} ));
    }
    else {
        diag explain %instruction;
        die;
    }
}


