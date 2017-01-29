use Moonshine::Test qw/:element/;

use Moonshine::Component;
use Data::Dumper;
my $instance = Moonshine::Component->new({ });

my @lazy_testing = qw/html base head link meta style title address 
article aside footer header h1 h2 h3 h4 h5 h6 hgroup nav section dd 
div dl dt figcaption figure hr li main ol p pre ul a abbr b bdi bdo 
br cite code data dfn em i kbd mark q rp rt rtc ruby s samp small span 
strong sub sup time u var wbr area audio img map track video embed 
object param source canvas noscript script del ins caption col 
colgroup table tbody td tfoot th thead tr button datalist fieldset 
form input label legend meter optgroup option output progress select 
textarea details dialog menu menuitem summary content element shadow template 
acronym applet basefont big blink center command content dir font frame 
frameset isindex keygen listing marquee multicol nextid noembed plaintext 
spacer strike tt xmp/;

my $counter = 0;
for my $element (@lazy_testing) {
    my $expected = sprintf '<%s></%s>', $element, $element;
    render_me(
        instance => $instance,
        func     => $element,
        expected => $expected,
    );
    my $class = 'class="blue"';
    $expected =~ s/($element)/$1 $class/;
    render_me(
        instance => $instance,
        func     => $element,
        args     => {
            class => 'blue',
        },
        expected => $expected,
    );
    $counter++;
    my $id = sprintf('green-%s', $counter);
    my $idd = sprintf('id="%s"', $id);
    $expected =~ s/($class)/$1 $idd/;
    render_me(
        instance => $instance,
        func     => $element,
        args     => {
            class => 'blue',
            id => $id,
        },
        expected => $expected,
    );
}

sunrise();

1;
