#! perl
# Copyright (C) 2008-2010, Parrot Foundation.

use strict;
use warnings;
use lib qw( . lib ../lib ../../lib );

use Test::More tests => 2;
use Parrot::Distribution;

=head1 NAME

t/codingstd/c_arg_assert.t - checks that all the headerizer asserts are used

=head1 SYNOPSIS

    # test all files
    % prove t/codingstd/c_arg_assert.t

=head1 DESCRIPTION

Finds all the argument guards generated by headerizer (asserts to enforce the
non-NULLness of specially marked pointers) that are actually used.
Verifies that macros are invoked on a sane position.

=head1 SEE ALSO

L<docs/pdds/pdd07_codingstd.pod>

=cut

my @files = Parrot::Distribution->new()->get_c_language_files();

check_asserts(@files);

sub check_asserts {
    my @files = @_;

    my @defines;
    my %usages;
    my @misplaced;

    # first, find the definitions and the usages in all files
    diag('finding macro definitions and invocations');
    foreach my $file (@files) {
        my $path     = $file->path();
        my @lines    = $file->read();
        my $fulltext = join('', @lines);
        foreach my $line (@lines) {
            if ( my ($func) = $line =~ m/^#define ASSERT_ARGS_([_a-zA-Z0-9]+)\s/s ) {
                push @defines, [$func, $path];
            }

            if ( my ($func) = $line =~ m/^\s+ASSERT_ARGS\(([_a-zA-Z0-9]+)\)$/ ) {
                $usages{$func} = 1;

                # The ASSERT_ARGS macro needs to follow an opening curly bracket
                if ($fulltext !~ m/\)(?:\n| )\{\s*ASSERT_ARGS\($func\)\n/s) {
                    push @misplaced, [$func, $path];
                }
            }
        }
    }

    # next, cross reference them.
    my @missing = grep { ! exists($usages{$_->[0]}) } @defines;
    # skip yet unused io_userhandle vtable functions [GH #796]
    @missing = grep { $_->[0] !~ /^io_userhandle_/ } @missing;
    ok(! @missing, 'no unused assert macros');
    if (@missing) {
        diag('unused assert macros found:');
        foreach (sort { $a->[1] . $a->[0] cmp $b->[1] . $b->[0]} @missing) {
            diag($_->[1] . ': ' . $_->[0]);
        }
        diag(scalar(@missing) . ' unused assert macros found in total.');
    }

    ok(! @misplaced, 'macros used in correct position');
    if (@misplaced) {
        diag(q{The following macros exist but aren't at the top of their function:});
        foreach (sort @misplaced) {
            diag($_->[1] . ': ' . $_->[0]);
        }
        diag(scalar(@misplaced) . ' misplaced macros found in total.');
    }
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
