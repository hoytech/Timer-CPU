package Timer::CPU;

our $VERSION = '0.001';

use strict;

use Math::Int64;


require XSLoader;   
XSLoader::load('Timer::CPU', $VERSION);


sub measure {
  my $callback = shift;

  die "measure needs code ref" unless ref $callback eq 'CODE';

  my $value = "\x00" x 8;

  measure_XS($callback, $value);

  return Math::Int64::native_to_int64($value);
}



1;




=head1 NAME

Timer::CPU - Precise user-space timer using the CPU clock

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Timer-CPU github repo|https://github.com/hoytech/Timer-CPU>

=head1 AUTHOR

Doug Hoyte, C<< <doug@hcsw.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2013 Doug Hoyte.

This module is licensed under the same terms as perl itself.
