package Archive::SimpleExtractor;

use warnings;
use strict;
use Module::Load;
use Module::Load::Conditional qw/can_load/;
$Module::Load::Conditional::VERBOSE = 1;

=head1 NAME

Archive::SimpleExtractor - simple module for extract archives

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.03';


=head1 SYNOPSIS

    use Archive::SimpleExtractor;

    my $extractor = new Archive::SimpleExtractor;
    
    @res = $extractor->extract(archive => 'archive.tar.bz2', dir => './somedir', tree => 1);

=cut

our $extentions = {
                    'zip'       => 'Archive::SimpleExtractor::Zip',
                    'rar'       => 'Archive::SimpleExtractor::Rar',
                    'tar'       => 'Archive::SimpleExtractor::Tar',
                    'tgz'       => 'Archive::SimpleExtractor::Tar',
                    'tar.gz'    => 'Archive::SimpleExtractor::Tar',
                    'tar.bz2'   => 'Archive::SimpleExtractor::Tar',
                };

=head1 METHODS

=head2 new

Returns a new object

=cut

sub new {
    my $self = shift;
    $self = bless {}, $self;
    return $self;
}

=head2 extract

    @res = $extractor->extract(archive => $archive_file, dir => $destination_dir, [tree => 1]);

extract files from archive

Atributes HASH:



archive => ...

path to you archive file



dir => ...

path will be unpacked archive



tree => 1

By default extractor unpacked arhive without subdirectories, but all files have been extracted in source dir. If you want save stucture set this argument.



Returns ARRAY:

$res[0] - success status. If 1 then OK else error

$res[1] - message or error string

=cut

sub extract {
    my $self = shift;
    my %arguments = @_;
        return (0, 'Bad atributes') unless $arguments{archive} && $arguments{dir};
    $arguments{dir} .= '/' unless $arguments{dir} =~ m/\/$/; # for zip
        return (0, 'No source directory') unless -d $arguments{dir};
    my ($res, $extractor) = $self->have_extractor($arguments{archive});
        return (0, $extractor) unless $res;
    my @result = $extractor->extract(%arguments);
    return @result;
}

=head2 have_extractor

Check extractor

=cut

sub have_extractor {
    my $self = shift;
    my $filename = shift;
    return (0, 'No file') unless $filename;
    my $reg_exp = join('|', keys %{$extentions});
    $reg_exp = qr/$reg_exp/;
    my ($ext) = $filename =~ /\.($reg_exp)$/;
    return (0, 'No Extractor') unless $extentions->{$ext};
    my $extractor = $extentions->{$ext};
    return can_load(modules => {$extractor => 0.0}) ? (1, $extractor) : (0, 'Bad Extractor');
}

=head1 AUTHOR

Sergey Tomoulevitch, C<< <phoinix.public at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-archive-simpleextractor at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Archive-SimpleExtractor>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Archive::SimpleExtractor


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Archive-SimpleExtractor>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Archive-SimpleExtractor>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Archive-SimpleExtractor>

=item * Search CPAN

L<http://search.cpan.org/dist/Archive-SimpleExtractor/>

=back


=head1 COPYRIGHT & LICENSE

Copyright 2009 Sergey Tomoulevitch.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Archive::SimpleExtractor
