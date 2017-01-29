use strict;
use warnings;
use feature qw/say/;

my @elements = qw/html base head link meta style title address 
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


open (my $fh, '>', 'quick_pod.txt') or die "cant $!";

for my $element ( @elements ) {
	print $fh "=head2 ${element} \n\n";
	print $fh sprintf '    $self->%s()%s', $element, "\n\n";    
	print $fh sprintf "    <%s></%s>\n\n", $element, $element;
};

close $fh;
