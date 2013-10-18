use strict;
use warnings;

use Coolinar;

my $app = Coolinar->apply_default_middlewares(Coolinar->psgi_app);
$app;

