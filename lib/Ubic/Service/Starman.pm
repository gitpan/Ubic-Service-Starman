use strict;
use warnings;
package Ubic::Service::Starman;
{
  $Ubic::Service::Starman::VERSION = '0.001';
}

# Set the plackup bin to starman
sub BEGIN { $ENV{'UBIC_SERVICE_PLACKUP_BIN'} = 'starman'; }

use base qw(Ubic::Service::Plack);

use Ubic::Daemon::PidState;

# ABSTRACT: Helper for running psgi applications with Starman

sub new {
    my ($class, %args ) = @_;

    $args{server} = 'Starman';
    return $class->SUPER::new( %args );
}

sub reload {
    my ( $self ) = @_;

    my $pid_data = Ubic::Daemon::PidState->new($self->pidfile)->read;
    kill HUP => $pid_data->{daemon};
    return 'reloaded';
}



1;

__END__
=pod

=head1 NAME

Ubic::Service::Starman - Helper for running psgi applications with Starman

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use Ubic::Service::Starman;
    return Ubic::Service::Starman->new({
        server_args => {
            listen => "/tmp/app.sock",
        },
        app => "/var/www/app.psgi",
        status => sub { ... },
        port => 4444,
        ubic_log => '/var/log/app/ubic.log',
        stdout => '/var/log/app/stdout.log',
        stderr => '/var/log/app/stderr.log',
        user => "www-data",
    });

=head1 DESCRIPTION

This service is a common ubic wrap for psgi applications.
It uses starman for running these applications.

It is a very simple wrapper around L<Ubic::Service::Plack> that
uses L<starman> as the binary instead of L<plackup>.  It
defaults the C<server> argument to 'Starman' so you don't have to pass
it in, and adds the ability to reload (which will gracefully restart
your L<Starman> workers without any connections lost) using
C<ubic reload service_name>.

=head1 NAME

Ubic::Service::Starman - ubic service base class for psgi applications

=head1 METHODS

=over

=item reload

Reload adds the ability to send a C<HUP> signal to the L<Starman> server
to gracefully reload your app and all the workers without losing any
connections.

=back

=head1 AUTHOR

William Wolf <throughnothing@gmail.com>

=head1 COPYRIGHT AND LICENSE


William Wolf has dedicated the work to the Commons by waiving all of his
or her rights to the work worldwide under copyright law and all related or
neighboring legal rights he or she had in the work, to the extent allowable by
law.

Works under CC0 do not require attribution. When citing the work, you should
not imply endorsement by the author.

=cut

