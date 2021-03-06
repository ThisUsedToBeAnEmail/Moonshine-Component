# NAME

Moonshine::Component - HTML Component base.

# VERSION

Version 0.01

# SYNOPSIS

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

# BASE Components

## html 

    $self->html()

    <html></html>

## base 

    $self->base()

    <base></base>

## head 

    $self->head()

    <head></head>

## link 

    $self->link()

    <link></link>

## meta 

    $self->meta()

    <meta></meta>

## style 

    $self->style()

    <style></style>

## title 

    $self->title()

    <title></title>

## address 

    $self->address()

    <address></address>

## article 

    $self->article()

    <article></article>

## aside 

    $self->aside()

    <aside></aside>

## footer 

    $self->footer()

    <footer></footer>

## header 

    $self->header()

    <header></header>

## h1 

    $self->h1()

    <h1></h1>

## h2 

    $self->h2()

    <h2></h2>

## h3 

    $self->h3()

    <h3></h3>

## h4 

    $self->h4()

    <h4></h4>

## h5 

    $self->h5()

    <h5></h5>

## h6 

    $self->h6()

    <h6></h6>

## hgroup 

    $self->hgroup()

    <hgroup></hgroup>

## nav 

    $self->nav()

    <nav></nav>

## section 

    $self->section()

    <section></section>

## dd 

    $self->dd()

    <dd></dd>

## div 

    $self->div()

    <div></div>

## dl 

    $self->dl()

    <dl></dl>

## dt 

    $self->dt()

    <dt></dt>

## figcaption 

    $self->figcaption()

    <figcaption></figcaption>

## figure 

    $self->figure()

    <figure></figure>

## hr 

    $self->hr()

    <hr></hr>

## li 

    $self->li()

    <li></li>

## main 

    $self->main()

    <main></main>

## ol 

    $self->ol()

    <ol></ol>

## p 

    $self->p()

    <p></p>

## pre 

    $self->pre()

    <pre></pre>

## ul 

    $self->ul()

    <ul></ul>

## a 

    $self->a()

    <a></a>

## abbr 

    $self->abbr()

    <abbr></abbr>

## b 

    $self->b()

    <b></b>

## bdi 

    $self->bdi()

    <bdi></bdi>

## bdo 

    $self->bdo()

    <bdo></bdo>

## br 

    $self->br()

    <br></br>

## cite 

    $self->cite()

    <cite></cite>

## code 

    $self->code()

    <code></code>

## data 

    $self->data()

    <data></data>

## dfn 

    $self->dfn()

    <dfn></dfn>

## em 

    $self->em()

    <em></em>

## i 

    $self->i()

    <i></i>

## kbd 

    $self->kbd()

    <kbd></kbd>

## mark 

    $self->mark()

    <mark></mark>

## q 

    $self->q()

    <q></q>

## rp 

    $self->rp()

    <rp></rp>

## rt 

    $self->rt()

    <rt></rt>

## rtc 

    $self->rtc()

    <rtc></rtc>

## ruby 

    $self->ruby()

    <ruby></ruby>

## s 

    $self->s()

    <s></s>

## samp 

    $self->samp()

    <samp></samp>

## small 

    $self->small()

    <small></small>

## span 

    $self->span()

    <span></span>

## strong 

    $self->strong()

    <strong></strong>

## sub 

    $self->sub()

    <sub></sub>

## sup 

    $self->sup()

    <sup></sup>

## time 

    $self->time()

    <time></time>

## u 

    $self->u()

    <u></u>

## var 

    $self->var()

    <var></var>

## wbr 

    $self->wbr()

    <wbr></wbr>

## area 

    $self->area()

    <area></area>

## audio 

    $self->audio()

    <audio></audio>

## img 

    $self->img()

    <img></img>

## map 

    $self->map()

    <map></map>

## track 

    $self->track()

    <track></track>

## video 

    $self->video()

    <video></video>

## embed 

    $self->embed()

    <embed></embed>

## object 

    $self->object()

    <object></object>

## param 

    $self->param()

    <param></param>

## source 

    $self->source()

    <source></source>

## canvas 

    $self->canvas()

    <canvas></canvas>

## noscript 

    $self->noscript()

    <noscript></noscript>

## script 

    $self->script()

    <script></script>

## del 

    $self->del()

    <del></del>

## ins 

    $self->ins()

    <ins></ins>

## caption 

    $self->caption()

    <caption></caption>

## col 

    $self->col()

    <col></col>

## colgroup 

    $self->colgroup()

    <colgroup></colgroup>

## table 

    $self->table()

    <table></table>

## tbody 

    $self->tbody()

    <tbody></tbody>

## td 

    $self->td()

    <td></td>

## tfoot 

    $self->tfoot()

    <tfoot></tfoot>

## th 

    $self->th()

    <th></th>

## thead 

    $self->thead()

    <thead></thead>

## tr 

    $self->tr()

    <tr></tr>

## button 

    $self->button()

    <button></button>

## datalist 

    $self->datalist()

    <datalist></datalist>

## fieldset 

    $self->fieldset()

    <fieldset></fieldset>

## form 

    $self->form()

    <form></form>

## input 

    $self->input()

    <input></input>

## label 

    $self->label()

    <label></label>

## legend 

    $self->legend()

    <legend></legend>

## meter 

    $self->meter()

    <meter></meter>

## optgroup 

    $self->optgroup()

    <optgroup></optgroup>

## option 

    $self->option()

    <option></option>

## output 

    $self->output()

    <output></output>

## progress 

    $self->progress()

    <progress></progress>

## select 

    $self->select()

    <select></select>

## textarea 

    $self->textarea()

    <textarea></textarea>

## details 

    $self->details()

    <details></details>

## dialog 

    $self->dialog()

    <dialog></dialog>

## menu 

    $self->menu()

    <menu></menu>

## menuitem 

    $self->menuitem()

    <menuitem></menuitem>

## summary 

    $self->summary()

    <summary></summary>

## element 

    $self->element()

    <element></element>

## shadow 

    $self->shadow()

    <shadow></shadow>

## template 

    $self->template()

    <template></template>

## acronym 

    $self->acronym()

    <acronym></acronym>

## applet 

    $self->applet()

    <applet></applet>

## basefont 

    $self->basefont()

    <basefont></basefont>

## big 

    $self->big()

    <big></big>

## blink 

    $self->blink()

    <blink></blink>

## center 

    $self->center()

    <center></center>

## command 

    $self->command()

    <command></command>

## content 

    $self->content()

    <content></content>

## dir 

    $self->dir()

    <dir></dir>

## font 

    $self->font()

    <font></font>

## frame 

    $self->frame()

    <frame></frame>

## frameset 

    $self->frameset()

    <frameset></frameset>

## isindex 

    $self->isindex()

    <isindex></isindex>

## keygen 

    $self->keygen()

    <keygen></keygen>

## listing 

    $self->listing()

    <listing></listing>

## marquee 

    $self->marquee()

    <marquee></marquee>

## multicol 

    $self->multicol()

    <multicol></multicol>

## nextid 

    $self->nextid()

    <nextid></nextid>

## noembed 

    $self->noembed()

    <noembed></noembed>

## plaintext 

    $self->plaintext()

    <plaintext></plaintext>

## spacer 

    $self->spacer()

    <spacer></spacer>

## strike 

    $self->strike()

    <strike></strike>

## tt 

    $self->tt()

    <tt></tt>

## xmp 

    $self->xmp()

    <xmp></xmp>

# AUTHOR

LNATION, `<thisusedtobeanemail at gmail.com>`

# BUGS

# ACKNOWLEDGEMENTS

# LICENSE AND COPYRIGHT

Copyright 2017 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

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
