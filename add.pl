#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib qw(..);
use JSON qw( );

use GD;

print "file: $ARGV[0]\n";
print "x: $ARGV[1]\n";
print "y: $ARGV[2]\n";
print "width: $ARGV[3]\n";
print "height: $ARGV[4]\n";
print "url: $ARGV[5]\n";
print "name: $ARGV[6]\n";
print "counter id: $ARGV[7]\n";

#open (my $dir, "<", "directory.json") || die "file not found";
#my $directory = <$dir>;
#close ($dir);

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

my $fields = $json->encode( $data->{fields} );

my @data2 = $json->decode($fields);

my $urg = pop( @data2 );


my $last = pop( $urg );
push( $urg, $last );


my $wantadd = {
    xy => $ARGV[1] . $ARGV[2],
    width => $ARGV[3],
    height => $ARGV[4],
    url => $ARGV[5],
    name => $ARGV[6],
    counter => $ARGV[7],
    hits => 1,
    tare => 1,
    time => time,
};

push( $urg, $wantadd );
push( @data2, $urg );

my $fleshedout = {
	fields => @data2
};

	print $json->encode($fleshedout)."\n";

print "\n\n";

open my $fh, ">", "directory.json";
print $fh $json->encode($fleshedout);
close $fh;

print "\n";

my $srcImage = GD::Image->newFromPng($ARGV[0],1);

for (my $i=0; $i < $ARGV[3]; $i++ )
{
	for (my $j=0; $j < $ARGV[4]; $j++ )
	{
		my $myImage = GD::Image->new(10,10,1);
		$myImage->copy($srcImage,0,0,10*$i,10*$j,10,10);
		my $pngData = $myImage->png;
		my $firstterm = $ARGV[1] + $i;
		my $secondterm = $ARGV[2] + $j;
		if ( $firstterm < 10 )
		{
			$firstterm = "0" . $firstterm;
		}
		if ( $secondterm < 10 )
		{
			$secondterm = "0" . $secondterm;
		}
		my $outname = "images/" . $firstterm . $secondterm . ".png";
		open (PICTURE, ">", $outname);
		binmode PICTURE;
		print PICTURE $myImage->png;
#		print $outx $myImage->png;
		close PICTURE;
	}
}

system "git add .";
system "git commit * -m \"Another new customer!\"";
system "git push";
