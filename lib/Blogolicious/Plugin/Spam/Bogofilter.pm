package Blogolicious::Plugin::Spam::Bogofilter;

use common::sense;
use Moo;

use Log::Any;
use IPC::Open3;

sub rate {
    my $self = shift;

    return;
}

sub spam {
    my $self = shift;

    return;
}

sub ham {
    my $self = shift;

    return;
}

sub run_bogofilter {
    my $self = shift;
    my $args = shift;
    my $data = shift;
    my $pid = open3(my $in_fd, my $out_fd, undef, $self->bogofilter_path, @$args);
    print $in_fd $data;
    close $in_fd;
    my $out;
    while(<$out_fd>) {$out .= $_ ; print $out}
    waitpid( $pid, 0 );
    my $child_exit_status = $? >> 8;
    chomp ($out);
    return split(/\s+/,$out,2);
}


has 'bogofilter_path' => (
    is => 'ro',
    isa => sub {
        if (! -x $_[0]) {
            croak("$_[0] is not executable")
        }
    },
    default => sub {
        # this probably should search path via some clever module...
        my $bogofilter_bin = `which bogofilter`;
        chomp $bogofilter_bin;
        return $bogofilter_bin;
    }
);

has 'db_dir' => (
    is => 'ro',
#    isa => sub {};
    default => sub {'.bogofilter_db'},
);

sub _format_data {
    my $self = shift;
    my $data = shift;
    my $out;
    if (defined($data->{'headers'})) {
        while(my ($k, $v) = each( %{ $data->{'headers'} } )) {
            $out .= $k . ": " . $self->_sanitize_header($v)
        }
    }
    $out .= "\n\n";
    if (defined($data->{'data'})) {
        $out .= $data->{'data'}
    }
    return $out;
}

sub _sanitize_header {
    my $self = shift;
    return;
}

1;
__END__

=head1 NAME

Blogolicious::Plugins::Spam::Bogofilter - spam detection based on bogofilter

=head1 DESCRIPTION
