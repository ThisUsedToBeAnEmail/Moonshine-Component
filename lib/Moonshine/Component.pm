package Moonshine::Component;

use 5.006;
use strict;
use warnings;

use Moonshine::Element;
use Params::Validate qw(:all);
use Ref::Util qw(:all);

use feature qw/switch/;
no if $] >= 5.017011, warnings => 'experimental::smartmatch';

our @ISA; { @ISA = "UNIVERSAL::Object" };
our %HAS;

=head1 NAME

Moonshine::Component - HTML Component base.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    package Moonshine::Component::Glyphicon;

    use Moonshine::Util qw/join_class prepend_str/;

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
        if (my $class = join_class($modify_args->{switch_base}, $modify_args->{switch})){
            $base_args->{class} = prepend_str($class, $base_args->{class});
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

=cut

BEGIN {
    my $fields = $Moonshine::Element::HAS{"attribute_list"}->();
    my %html_spec = map { $_ => 0 } @{$fields}, qw/data tag/;

    %HAS = (
        html_spec     => sub { \%html_spec },
        modifier_spec => sub { { } },
    );

    my @lazy_components = qw/html base head link meta style title address 
    article aside footer header h1 h2 h3 h4 h5 h6 hgroup nav section dd div 
    dl dt figcaption figure hr li main ol p pre ul a abbr b bdi bdo br cite 
    code data dfn em i kbd mark q rp rt rtc ruby s samp small span strong sub 
    sup time u var wbr area audio img map track video embed object param source 
    canvas noscript script del ins caption col colgroup table tbody td tfoot th 
    thead tr button datalist fieldset form input label legend meter optgroup option 
    output progress select textarea details dialog menu menuitem summary element 
    shadow template acronym applet basefont big blink center command content 
    dir font frame frameset isindex keygen listing marquee multicol nextid noembed 
    plaintext spacer strike tt xmp/;

    
    for my $component (@lazy_components) {
        {
            no strict 'refs';
            *{"${component}"} = sub {
                my $self = shift;

                my ( $base_args, $build_args ) = $self->validate_build(
                    {
                        params => $_[0] // {},
                        spec => {
                            tag  => { default => $component },
                            data => 0,
                        }
                    }
                );

                return Moonshine::Element->new($base_args);
              }
        };
    }
}

sub validate_build {
    my $self = shift;
    my %args = validate_with(
        params => $_[0],
        spec   => {
            params => { type => HASHREF },
            spec   => { type => HASHREF },
        }
    );

    my %html_spec   = %{ $self->{html_spec} };
    my %html_params = ();

    my %modifier_spec   = %{ $self->{modifier_spec} };
    my %modifier_params = ();

    my %combine = ( %{ $args{params} }, %{ $args{'spec'} } );

    for my $key ( keys %combine ) {
        my $spec = $args{spec}->{$key};
        if ( is_hashref($spec) ) {
            defined $spec->{build} and next;
            if ( exists $spec->{base} ) {
                my $param = delete $args{params}->{$key};
                my $spec  = delete $args{spec}->{$key};
                $html_params{$key} = $param if $param;
                $html_spec{$key}   = $spec  if $spec;
                next;
            }
        }

        if ( exists $html_spec{$key} ) {
            if ( defined $spec ) {
                $html_spec{$key} = delete $args{spec}->{$key};
            }
            if ( exists $args{params}->{$key} ) {
                $html_params{$key} = delete $args{params}->{$key};
            }
            next;
        }
        elsif ( exists $modifier_spec{$key} ) {
            if ( defined $spec ) {
                $modifier_spec{$key} = delete $args{spec}->{$key};
            }
            if ( exists $args{params}->{$key} ) {
                my $params = $args{params}->{$key};
                $modifier_params{$key} = delete $args{params}->{$key};
            }
            next;
        }
    }

    my %base = validate_with(
        params => \%html_params,
        spec   => \%html_spec,
    );

    my %build = validate_with(
        params => $args{params},
        spec   => $args{spec},
    );

    my %modifier = validate_with(
        params => \%modifier_params,
        spec   => \%modifier_spec,
    );

    for my $element (qw/before_element after_element children/) {
        if ( defined $modifier{$element} ) {
            my @elements = $self->build_elements( @{ $modifier{$element} } );
            $base{$element} = \@elements;
        }
    }
    
    if (scalar keys %modifier and $self->can('modify')) {
        return $self->modify(\%base, \%build, \%modifier);
    }

    return \%base, \%build, \%modifier;
}

sub build_elements {
    my $self = shift;
    my @elements_build_instructions = @_;

    my @elements;
    for my $build (@elements_build_instructions) {
        my $element;
        if ( is_blessed_ref($build) and $build->isa('Moonshine::Element') ) {
            $element = $build;
        }
        elsif ( my $action = delete $build->{action} ) {
            $self->can($action) and $element = $self->$action($build)
              or die "cannot find action - $action";
        }
        elsif ( defined $build->{tag} ) {
            $element = Moonshine::Element->new($build);
        }
        else {
            my $error_string =
              join( ", ", map { "$_: $build->{$_}" } keys %{$build} );
            die sprintf "no instructions to build the element: %s",
              $error_string;
        }
        push @elements, $element;
    }

    return @elements;
}
            
1;

__END__

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moonshine-world at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Moonshine-World>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1;
