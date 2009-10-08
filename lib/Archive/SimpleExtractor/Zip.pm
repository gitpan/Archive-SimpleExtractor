package Archive::SimpleExtractor::Zip;

use warnings;
use strict;
use Archive::Zip qw/ :ERROR_CODES :CONSTANTS /;
use File::Find;
use File::Copy;
use File::Path qw/rmtree/;


=head1 NAME

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';

our $zip = Archive::Zip->new();

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 new

=cut

sub extract {
    my $self = shift;
    my %arguments = @_;
    unless ( $zip->read($arguments{archive}) == AZ_OK ) { return (0, 'Can not read archive file'.$arguments{archive}) }
    if ($arguments{tree}) {
        warn 1;
        unless ( $zip->extractTree( '' , $arguments{dir} ) == AZ_OK ) { return (0, 'Can not extract archive' ) }
        return (1, 'Extract finished with directory tree');
    } else {
        my $tmp_dir = '.tmp'.rand(10000).'/';
            mkdir $arguments{dir}.$tmp_dir || return (0, 'Can not create temp_directory '.$! );
            $tmp_dir = $arguments{dir}.$tmp_dir;
        unless ( $zip->extractTree( '' , $tmp_dir ) == AZ_OK ) { return (0, 'Can not extract archive' ) }
        find(   { wanted => sub {
                                    if (-f $File::Find::name) {
                                        my ($filename) = $File::Find::name =~ /\/([^\/]+)$/;
                                        copy($File::Find::name, $arguments{dir}.$filename);
                                    }
                                },
                                no_chdir => 1,
                },
                $tmp_dir,
            );
        rmtree($tmp_dir);
        return (1, 'Extract finished without directory tree');
    }
}

1;
