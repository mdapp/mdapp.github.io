#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib qw(..);
use JSON qw( );

use GD;
use GD::Simple;

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", "directory.json")
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);

print $json->encode($data);
print "\n";

my @fields = $json->encode( $data->{fields} );
my @datum = @{$json->decode($fields[0])};

my $srcImage = GD::Image->newFromPng('kabuki.png',1);
my $datur;
my $myImage = $srcImage;

my $black = $myImage->colorAllocate(0,0,0);
my $gray = $myImage->colorAllocate(100,100,100);

        foreach $datur ( @datum ) {
                my $datumr = $datur->{'xy'};
                my $xcoord = 4 * substr $datumr, 0, 2;
                my $ycoord = 4 * substr $datumr, 2;
                my $width = 4 * $datur->{'width'};
                my $height = 4 * $datur->{'height'};
                print $datumr . " " . $xcoord . " " . $ycoord . " " . $datur->{'width'} . " " . $datur->{'height'};
                print "<br>\n";
	
		$myImage->filledRectangle(17+$xcoord,17+$ycoord,17+$xcoord+$width,17+$ycoord+$height,$black);
		$myImage->rectangle(17+$xcoord,17+$ycoord,17+$xcoord+$width,17+$ycoord+$height,$gray);
        }


print "\n";


	open (PICTURE, ">", 'kabuki.png');
	binmode PICTURE;
	print PICTURE $myImage->png;
	close PICTURE;
	


system "git add .";
system "git commit * -m \"Another new kabuki\"";
system "git push";
