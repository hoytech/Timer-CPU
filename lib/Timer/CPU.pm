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

    use Timer::CPU;

    my $elapsed_ticks = Timer::CPU::measure(sub {
      ## Do stuff
    });

=head1 DESCRIPTION

For most timing operations, L<Time::HiRes> is great. However, it usually does a syscall (except eg on linux systems with gettimeofday in VDSO) which adds noise, and is not as precise as possible.

This module is a pure user-space timing library that should be quite precise. To measure the time of an operation, pass a callback to C<Timer::CPU::measure>. It will return the number of CPU ticks that elapsed while running your callback. Actually, what is returned is a L<Math::Int64> object so as to support 32-bit perls.

On x86, this module uses the C<rdtsc> assembly instruction in order to access the time-stamp counter.




=head1 CAVEATS

There are many caveats to this timing technique, but there are caveats to all timing techniques.

The biggest problem with using CPU ticks is that we don't necessarily know the real-time duration of a tick. Even if you figure out the clock frequency, maybe with L<Sys::Info::Device::CPU>, you can't be sure that the frequency hasn't changed while running your callback. Because of these limitations, this module is most useful for comparing the relative difference between two events on the same computer, not for absolute timing measurements.

If you have multiple CPUs/cores your process may have been context switched to another CPU which can corrupt your timing data since the clocks aren't synchronized between CPUs. Unless your task is very short, you should consider pegging your process to a particular CPU.

If the machine is hibernated or suspended, data will be corrupted also.

Operating systems can disable access to the time-stamp counter by setting a bit in the CR4 register.




=head1 RETURNING VALUES FROM CALLBACK

Note that the interface doesn't allow returning data from the callback. The callback is in fact called in void context. However, you can pass in a closure as the callback and get data out of it that way:

    my $output;

    my $elapsed_ticks = Timer::CPU::measure(sub {
      $output = do_stuff();
    });




=head1 BUGS/TODO

Is this the right module name/namespace?

Support more processors

Should it serialize the instruction stream with C<CPUID>?

L<Optionally use HPET?|http://blog.fpmurphy.com/2009/07/linux-hpet-support.html>



=head1 SEE ALSO

L<Timer-CPU github repo|https://github.com/hoytech/Timer-CPU>

L<Time::HiRes>

L<Time-Stamp Counter|http://en.wikipedia.org/wiki/Time_Stamp_Counter>



=head1 AUTHOR

Doug Hoyte, C<< <doug@hcsw.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2013 Doug Hoyte.

This module is licensed under the same terms as perl itself.
