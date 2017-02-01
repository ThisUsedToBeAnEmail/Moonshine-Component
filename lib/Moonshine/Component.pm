package Moonshine::Component;

use strict;
use warnings;

use Moonshine::Element;
use Moonshine::Magic;
use Params::Validate qw(:all);
use Ref::Util qw(:all);
use feature qw/switch/;
no if $] >= 5.017011, warnings => 'experimental::smartmatch';

extends "UNIVERSAL::Object";

our $VERSION = '0.03';

BEGIN {
    my $fields = $Moonshine::Element::HAS{"attribute_list"}->();
    my %html_spec = map { $_ => 0 } @{$fields}, qw/data tag/;

    has (
        html_spec     => sub { \%html_spec },
        modifier_spec => sub { { } },
    );
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

    my %html_spec   = %{ $self->html_spec };
    my %html_params = ();

    my %modifier_spec   = %{ $self->modifier_spec };
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

=head1 NAME

Moonshine::Component - HTML Component base.

=head1 VERSION

Version 0.03

=cut

=head1 SYNOPSIS

    package Moonshine::Component::Glyphicon;

    use Moonshine::Util qw/join_class prepend_str/;

    extends 'Moonshine::Component';
    
    lazy_components (qw/span/)
    
    has (
        modifier_spec => sub { 
            {
                switch => 0,
                switch_base => 0,
            }
        }
    );

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

=head1 BASE Components

=head2 html 

    $self->html()

    <html></html>

=head2 base 

    $self->base()

    <base></base>

=head2 head 

    $self->head()

    <head></head>

=head2 link 

    $self->link()

    <link></link>

=head2 meta 

    $self->meta()

    <meta></meta>

=head2 style 

    $self->style()

    <style></style>

=head2 title 

    $self->title()

    <title></title>

=head2 address 

    $self->address()

    <address></address>

=head2 article 

    $self->article()

    <article></article>

=head2 aside 

    $self->aside()

    <aside></aside>

=head2 footer 

    $self->footer()

    <footer></footer>

=head2 header 

    $self->header()

    <header></header>

=head2 h1 

    $self->h1()

    <h1></h1>

=head2 h2 

    $self->h2()

    <h2></h2>

=head2 h3 

    $self->h3()

    <h3></h3>

=head2 h4 

    $self->h4()

    <h4></h4>

=head2 h5 

    $self->h5()

    <h5></h5>

=head2 h6 

    $self->h6()

    <h6></h6>

=head2 hgroup 

    $self->hgroup()

    <hgroup></hgroup>

=head2 nav 

    $self->nav()

    <nav></nav>

=head2 section 

    $self->section()

    <section></section>

=head2 dd 

    $self->dd()

    <dd></dd>

=head2 div 

    $self->div()

    <div></div>

=head2 dl 

    $self->dl()

    <dl></dl>

=head2 dt 

    $self->dt()

    <dt></dt>

=head2 figcaption 

    $self->figcaption()

    <figcaption></figcaption>

=head2 figure 

    $self->figure()

    <figure></figure>

=head2 hr 

    $self->hr()

    <hr></hr>

=head2 li 

    $self->li()

    <li></li>

=head2 main 

    $self->main()

    <main></main>

=head2 ol 

    $self->ol()

    <ol></ol>

=head2 p 

    $self->p()

    <p></p>

=head2 pre 

    $self->pre()

    <pre></pre>

=head2 ul 

    $self->ul()

    <ul></ul>

=head2 a 

    $self->a()

    <a></a>

=head2 abbr 

    $self->abbr()

    <abbr></abbr>

=head2 b 

    $self->b()

    <b></b>

=head2 bdi 

    $self->bdi()

    <bdi></bdi>

=head2 bdo 

    $self->bdo()

    <bdo></bdo>

=head2 br 

    $self->br()

    <br></br>

=head2 cite 

    $self->cite()

    <cite></cite>

=head2 code 

    $self->code()

    <code></code>

=head2 data 

    $self->data()

    <data></data>

=head2 dfn 

    $self->dfn()

    <dfn></dfn>

=head2 em 

    $self->em()

    <em></em>

=head2 i 

    $self->i()

    <i></i>

=head2 kbd 

    $self->kbd()

    <kbd></kbd>

=head2 mark 

    $self->mark()

    <mark></mark>

=head2 q 

    $self->q()

    <q></q>

=head2 rp 

    $self->rp()

    <rp></rp>

=head2 rt 

    $self->rt()

    <rt></rt>

=head2 rtc 

    $self->rtc()

    <rtc></rtc>

=head2 ruby 

    $self->ruby()

    <ruby></ruby>

=head2 s 

    $self->s()

    <s></s>

=head2 samp 

    $self->samp()

    <samp></samp>

=head2 small 

    $self->small()

    <small></small>

=head2 span 

    $self->span()

    <span></span>

=head2 strong 

    $self->strong()

    <strong></strong>

=head2 sub 

    $self->sub()

    <sub></sub>

=head2 sup 

    $self->sup()

    <sup></sup>

=head2 time 

    $self->time()

    <time></time>

=head2 u 

    $self->u()

    <u></u>

=head2 var 

    $self->var()

    <var></var>

=head2 wbr 

    $self->wbr()

    <wbr></wbr>

=head2 area 

    $self->area()

    <area></area>

=head2 audio 

    $self->audio()

    <audio></audio>

=head2 img 

    $self->img()

    <img></img>

=head2 map 

    $self->map()

    <map></map>

=head2 track 

    $self->track()

    <track></track>

=head2 video 

    $self->video()

    <video></video>

=head2 embed 

    $self->embed()

    <embed></embed>

=head2 object 

    $self->object()

    <object></object>

=head2 param 

    $self->param()

    <param></param>

=head2 source 

    $self->source()

    <source></source>

=head2 canvas 

    $self->canvas()

    <canvas></canvas>

=head2 noscript 

    $self->noscript()

    <noscript></noscript>

=head2 script 

    $self->script()

    <script></script>

=head2 del 

    $self->del()

    <del></del>

=head2 ins 

    $self->ins()

    <ins></ins>

=head2 caption 

    $self->caption()

    <caption></caption>

=head2 col 

    $self->col()

    <col></col>

=head2 colgroup 

    $self->colgroup()

    <colgroup></colgroup>

=head2 table 

    $self->table()

    <table></table>

=head2 tbody 

    $self->tbody()

    <tbody></tbody>

=head2 td 

    $self->td()

    <td></td>

=head2 tfoot 

    $self->tfoot()

    <tfoot></tfoot>

=head2 th 

    $self->th()

    <th></th>

=head2 thead 

    $self->thead()

    <thead></thead>

=head2 tr 

    $self->tr()

    <tr></tr>

=head2 button 

    $self->button()

    <button></button>

=head2 datalist 

    $self->datalist()

    <datalist></datalist>

=head2 fieldset 

    $self->fieldset()

    <fieldset></fieldset>

=head2 form 

    $self->form()

    <form></form>

=head2 input 

    $self->input()

    <input></input>

=head2 label 

    $self->label()

    <label></label>

=head2 legend 

    $self->legend()

    <legend></legend>

=head2 meter 

    $self->meter()

    <meter></meter>

=head2 optgroup 

    $self->optgroup()

    <optgroup></optgroup>

=head2 option 

    $self->option()

    <option></option>

=head2 output 

    $self->output()

    <output></output>

=head2 progress 

    $self->progress()

    <progress></progress>

=head2 select 

    $self->select()

    <select></select>

=head2 textarea 

    $self->textarea()

    <textarea></textarea>

=head2 details 

    $self->details()

    <details></details>

=head2 dialog 

    $self->dialog()

    <dialog></dialog>

=head2 menu 

    $self->menu()

    <menu></menu>

=head2 menuitem 

    $self->menuitem()

    <menuitem></menuitem>

=head2 summary 

    $self->summary()

    <summary></summary>

=head2 element 

    $self->element()

    <element></element>

=head2 shadow 

    $self->shadow()

    <shadow></shadow>

=head2 template 

    $self->template()

    <template></template>

=head2 acronym 

    $self->acronym()

    <acronym></acronym>

=head2 applet 

    $self->applet()

    <applet></applet>

=head2 basefont 

    $self->basefont()

    <basefont></basefont>

=head2 big 

    $self->big()

    <big></big>

=head2 blink 

    $self->blink()

    <blink></blink>

=head2 center 

    $self->center()

    <center></center>

=head2 command 

    $self->command()

    <command></command>

=head2 content 

    $self->content()

    <content></content>

=head2 dir 

    $self->dir()

    <dir></dir>

=head2 font 

    $self->font()

    <font></font>

=head2 frame 

    $self->frame()

    <frame></frame>

=head2 frameset 

    $self->frameset()

    <frameset></frameset>

=head2 isindex 

    $self->isindex()

    <isindex></isindex>

=head2 keygen 

    $self->keygen()

    <keygen></keygen>

=head2 listing 

    $self->listing()

    <listing></listing>

=head2 marquee 

    $self->marquee()

    <marquee></marquee>

=head2 multicol 

    $self->multicol()

    <multicol></multicol>

=head2 nextid 

    $self->nextid()

    <nextid></nextid>

=head2 noembed 

    $self->noembed()

    <noembed></noembed>

=head2 plaintext 

    $self->plaintext()

    <plaintext></plaintext>

=head2 spacer 

    $self->spacer()

    <spacer></spacer>

=head2 strike 

    $self->strike()

    <strike></strike>

=head2 tt 

    $self->tt()

    <tt></tt>

=head2 xmp 

    $self->xmp()

    <xmp></xmp>

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

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
