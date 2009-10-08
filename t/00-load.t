#!perl -T

use Test::More tests => 5;

BEGIN {
    use_ok( 'Archive::SimpleExtractor' );
    my $obj = new_ok 'Archive::SimpleExtractor';
    is (($obj->have_extractor('.zip'))[0], 1, 'Load Zip extractor');
    is (($obj->have_extractor('.rar'))[0], 1, 'Load Rar extractor');
    is (($obj->have_extractor('.tar'))[0], 1, 'Load Tar extractor');
}

diag( "Testing Archive::SimpleExtractor $Archive::SimpleExtractor::VERSION, Perl $], $^X" );
