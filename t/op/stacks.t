#! perl -w

# Tests for stack operations, currently push*, push_*_c and pop*
# where * != p.

# Assembler code is partially generated by subs at bottom of file

# Still to write: tests for (push|pop)_p(_c)?
#                 tests for warp, unwarp and set_warp

use Parrot::Test tests => 9;

output_is( <<"CODE", <<'OUTPUT', "pushi & popi" );
@{[ set_int_regs( sub { $_[0]} )]}
	pushi
@{[ set_int_regs( sub {-$_[0]} )]}
@{[ print_int_regs() ]}
	popi
@{[ print_int_regs() ]}
	end
CODE
0-1-2-3-4
-5-6-7-8-9
-10-11-12-13-14
-15-16-17-18-19
-20-21-22-23-24
-25-26-27-28-29
-30-31
01234
56789
1011121314
1516171819
2021222324
2526272829
3031
OUTPUT

SKIP: {skip("push_i_c not implemented",1);
output_is(<<"CODE", <<'OUTPUT', "push_i_c & popi");
@{[ set_int_regs( sub {$_[0]}) ]}
	push_i_c
@{[ print_int_regs() ]}
@{[ set_int_regs( sub {-$_[0]}) ]}
@{[ print_int_regs() ]}
	popi
@{[ print_int_regs() ]}
	end
CODE
01234
56789
1011121314
1516171819
2021222324
2526272829
3031
0-1-2-3-4
-5-6-7-8-9
-10-11-12-13-14
-15-16-17-18-19
-20-21-22-23-24
-25-26-27-28-29
-30-31
01234
56789
1011121314
1516171819
2021222324
2526272829
3031
OUTPUT
}

output_is(<<"CODE", <<'OUTPUT', 'pushs & pops');
@{[ set_str_regs( sub {$_[0]%2} ) ]}
	pushs
@{[ set_str_regs( sub {($_[0]+1) %2} ) ]}
@{[ print_str_regs() ]}
	print "\\n"
	pops
@{[ print_str_regs() ]}
	print "\\n"
	end
CODE
10101010101010101010101010101010
01010101010101010101010101010101
OUTPUT

SKIP: {skip("push_s_c not implemented", 1);
output_is(<<"CODE", <<'OUTPUT', 'push_s_c & pops');
@{[ set_str_regs( sub {$_[0]%2} ) ]}
	push_s_c
@{[ print_str_regs() ]}
	print "\\n"
@{[ set_str_regs( sub {($_[0]+1) %2} ) ]}
@{[ print_str_regs() ]}
	print "\\n"
	pops
@{[ print_str_regs() ]}
	print "\\n"
	end
CODE
01010101010101010101010101010101
10101010101010101010101010101010
01010101010101010101010101010101
OUTPUT
}

output_is(<<"CODE", <<'OUTPUT', 'pushn & popn');
@{[ set_num_regs( sub { "1.0".$_ } ) ]}
	pushn
@{[ set_num_regs( sub { "-1.0".$_} ) ]}
@{[ clt_num_regs() ]}
	print "Seem to have negative Nx\\n"
	popn
@{[ cgt_num_regs() ]}
	print "Seem to have positive Nx after pop\\n"
	branch ALLOK
ERROR:	print "not ok\\n"
ALLOK:	end
CODE
Seem to have negative Nx
Seem to have positive Nx after pop
OUTPUT

SKIP: { skip("push_n_c not yet implemented",1);
output_is(<<"CODE", <<'OUTPUT', 'push_n_c & popn');
@{[ set_num_regs( sub { "1.0".$_ } ) ]}
	push_n_c
@{[ cgt_num_regs() ]}
	print "Seem to have positive Nx before push\\n"
@{[ set_num_regs( sub { "-1.0".$_} ) ]}
@{[ clt_num_regs() ]}
	print "Seem to have negative Nx\\n"
	popn
@{[ cgt_num_regs() ]}
	print "Seem to have positive Nx after pop\\n"
	branch ALLOK
ERROR:	print "not ok\\n"
ALLOK:	end
CODE
Seem to have positive Nx before push
Seem to have negative Nx
Seem to have positive Nx after pop
OUTPUT
}

# Now, to make it do BAD THINGS!
output_is(<<"CODE",'No more I register frames to pop!','ENO I frames');
	popi
	end
CODE
output_is(<<"CODE",'No more N register frames to pop!','ENO N frames');
	popn
	end
CODE
output_is(<<"CODE",'No more S register frames to pop!','ENO S frames');
	pops
	end
CODE

# I'm lazy, and 32* as much code as needed isn't needed,
# if you follow...

# set integer registers to some value given by $code...
package main;
sub set_int_regs {
  my $code = shift;
  my $rt;
  for (0..31) {
    $rt .= "\tset I$_, ".&$code($_)."\n";
  }
  return $rt;
}
# print all integer registers, with newlines every five registers
sub print_int_regs {
  my ($rt, $foo);
  for (0..31) {
    $rt .= "\tprint I$_\n";
    $rt .= "\tprint \"\\n\"\n" unless ++$foo % 5;
  }
  $rt .= "\tprint \"\\n\"\n";
  return $rt;
}

# Set all string registers to values given by &$_[0](reg num)
sub set_str_regs {
  my $code = shift;
  my $rt;
  for (0..31) {
    $rt .= "\tset S$_, \"".&$code($_)."\"\n";
  }
  return $rt;
}
# print string registers, no additional prints
sub print_str_regs {
  my $rt;
  for (0..31) {
    $rt .= "\tprint S$_\n";
  }
  return $rt;
}

# Set "float" registers, &$_[0](reg num) should return string
sub set_num_regs {
  my $code = shift;
  my $rt;
  for (0..31) {
    $rt .= "\tset N$_, ".&$code($_[0])."\n";
  }
  return $rt;
}
# rather than printing all num regs, compare all ge 0
# if any are less, jump to ERROR
# sense of test may seem backwards, but isn't
sub cgt_num_regs {
  my $rt;
  for (0..31) {
    $rt .= "\tlt_n_nc_ic N$_, 0.0, ERROR\n";
  }
  return $rt;
}
# same, but this time lt 0
sub clt_num_regs {
  my $rt;
  for (0..31) {
    $rt .= "\tgt_n_nc_ic N$_, 0.0, ERROR\n";
  }
  return $rt;
}
