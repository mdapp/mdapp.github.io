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


my $usuallyBlankH = "";
my $usuallyBlankV = "";

if ( $ARGV[1] < 10 )
{
	$usuallyBlankH = "0";
}
if ( $ARGV[2] < 10 )
{
	$usuallyBlankV = "0";
}

my $wantadd = {
    xy => $usuallyBlankH . $ARGV[1] . $usuallyBlankV . $ARGV[2],
    width => $ARGV[3],
    height => $ARGV[4],
    url => $ARGV[5],
    name => $ARGV[6],
    counter => $ARGV[7],
    hits => 1,
    tare => 1,
    time => time,
};

my $dupe;

for my $record (@$urg ) {

my $isMatch = 0;
	for my $key (keys(%$record )) {
	my $val = $record->{$key};

#	print "XX:\n";
#	print $key;
#	print " .. ";
#	print $val;
#	print "\n";

	my $xy = $usuallyBlankH . $ARGV[1] . $usuallyBlankV . $ARGV[2];

	print $xy;
	if ( $key eq "xy" && $val eq $xy )
	{	
		$isMatch = 1;
#		print "MATCHa\n";
	}
}
	if ( $isMatch == 0 )
	{
		push( @$dupe, $record );
	}

}




push( @$dupe, $wantadd );
push( @data2, $dupe );

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
system "git commit * -m \"AUTO: Replaced Graphic\"";
system "git push";
