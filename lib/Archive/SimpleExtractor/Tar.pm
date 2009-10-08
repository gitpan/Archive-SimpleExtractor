package Archive::SimpleExtractor::Tar;

use warnings;
use strict;
use Archive::Tar;
use File::Find;
use File::Copy;
use File::Path qw/rmtree/;

=head1 NAME

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';

our $tar = Archive::Tar->new;

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 new

=cut

sub extract {
    my $self = shift;
    my %arguments = @_;
    my ($archive_file) = $arguments{archive} =~ /\/?([^\/]+)$/;
    copy($arguments{archive}, $arguments{dir}.$archive_file);
    chdir $arguments{dir};
    unless ( $tar->read($archive_file) ) { return (0, 'Can not read archive file'.$arguments{archive}) }
    my @files = $tar->extract();
    return (0, 'Can not extract archive' ) unless @files;
    if ($arguments{tree}) {
        unlink $archive_file;
        return (1, 'Extract finished with directory tree');
    } else {
        foreach my $file (@files) {
            next if -d $file->full_path;
            my ($filename) =  $file->full_path =~ /\/([^\/]+)$/;
            copy($file->full_path, $filename);
        }
        foreach my $item (<*>) {if (-d $item) {rmtree($item)}}
        unlink $archive_file;
        return (1, 'Extract finished without directory tree');
    }
}

1;
