
use Dreams qw/:all/;

use Moonshine::Component;

my $instance = Moonshine::Component->new({ });

render_me(
    instance => $instance,
    action => 'ul',
    expected => '<ul></ul>'
);

done_testing();

1;
