use lib 'lib';
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Blogolicious');
$t->get_ok('/blog/feed')
    ->status_is(200)
    ->content_like(qr/<feed/i)
    ->content_like(qr/<title/i)
    ->content_like(qr/<summary/i)
    ->content_like(qr/<entry/i);

done_testing();
