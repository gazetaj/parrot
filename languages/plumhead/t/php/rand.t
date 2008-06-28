#! perl
# Copyright (C) 2008, The Perl Foundation.
# $Id$

=head1 NAME

t/php/rand.t - Standard Library rand

=head1 SYNOPSIS

    % perl -I../lib plumhead/t/php/rand.t

=head1 DESCRIPTION

Tests PHP Standard Library rand
(implemented in F<languages/plumhead/src/common/php_rand.pir>).

See L<http://www.php.net/manual/en/ref.math.php>.

=cut

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use Test::More     tests => 11;

use Parrot::Test;

language_output_is( 'Plumhead', <<'CODE', <<'OUTPUT', 'getrandmax()', todo => 'awaiting compiler changes' );
<?php
  echo getrandmax(), "\n";
?>
CODE
2147483647
OUTPUT

language_output_like( 'Plumhead', <<'CODE', <<'OUTPUT', 'getrandmax(wrong param)' );
<?php
  echo getrandmax(42);
?>
CODE
/Wrong parameter count for/
OUTPUT

language_output_is( 'Plumhead', <<'CODE', <<'OUTPUT', 'mt_getrandmax()', todo => 'awaiting compiler changes' );
<?php
  echo mt_getrandmax(), "\n";
?>
CODE
2147483647
OUTPUT

language_output_like( 'Plumhead', <<'CODE', <<'OUTPUT', 'mt_rand()' );
<?php
  echo mt_rand();
?>
CODE
/\d+/
OUTPUT

language_output_like( 'Plumhead', <<'CODE', <<'OUTPUT', 'mt_rand(min, max)' );
<?php
  echo mt_rand(1, 10);
?>
CODE
/\d/
OUTPUT

language_output_is( 'Plumhead', <<'CODE', <<'OUTPUT', 'mt_srand()' );
<?php
  mt_srand();
?>
CODE
OUTPUT

language_output_is( 'Plumhead', <<'CODE', <<'OUTPUT', 'mt_srand(seed)' );
<?php
  mt_srand(42);
?>
CODE
OUTPUT

language_output_like( 'Plumhead', <<'CODE', <<'OUTPUT', 'rand()' );
<?php
  echo rand();
?>
CODE
/\d+/
OUTPUT

language_output_like( 'Plumhead', <<'CODE', <<'OUTPUT', 'rand(min, max)' );
<?php
  echo rand(1, 10);
?>
CODE
/\d/
OUTPUT

language_output_is( 'Plumhead', <<'CODE', <<'OUTPUT', 'srand()' );
<?php
  srand();
?>
CODE
OUTPUT

language_output_is( 'Plumhead', <<'CODE', <<'OUTPUT', 'srand(seed)' );
<?php
  srand(42);
?>
CODE
OUTPUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
