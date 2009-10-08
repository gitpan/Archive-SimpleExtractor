package Archive::SimpleExtractor::7z;

use warnings;
use strict;
use Compress::unLZMA qw/uncompressfile/;
use File::Find;
use File::Copy;
use File::Path qw/rmtree/;


=head1 NAME

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

our $command = '7z';

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 new

=cut

sub extract {
    my $self = shift;
    my %arguments = @_;
    warn $arguments{archive};
    my $data = uncompressfile($arguments{archive});
    warn $@;
    warn $data;
    return (1, 'Extract finished without directory tree');
}

1;
