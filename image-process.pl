#!/usr/bin/perl
use warnings;
use strict;

use 5.10.0;
use GD;
use GD::Text::Align;
use File::Basename;		# dirname(),fileparse(),basename()
use Getopt::Long;
use Data::Dumper;

my $PADDING = 20;


my $logo;
my $target_w;
my $target_h;
my @source_files;


my $arg_parser = Getopt::Long::Parser->new();
$arg_parser->getoptions(
	"logo|l=s"     => \$logo,
	"width|w=i"    => \$target_w,
	"height|h=i"   => \$target_h,
	"files|f=s{,}" => \@source_files
) or die ("Insufficient arguments");


die("No image files specified.") unless (@source_files);


my $image_count = scalar(@source_files);
my $counter     = 0;


for my $img_file (@source_files)
{
	# TODO: improve filename processing
	#       recognise image type, adjust output filetype accordingly
	#       refactor code

	++$counter;
	my $length = length $image_count;
	my $status = sprintf("[ % ${length}u / %u ]    Processing %s",
		$counter,
		$image_count,
		$img_file
	);
	say $status;


	GD::Image->trueColor(1);


	my $gd_logo;
	my $logo_w;
	my $logo_h;
	if ($logo)
	{
		$gd_logo           = GD::Image->new($logo) or die;
		my $transparent    = $gd_logo->colorAllocateAlpha(0,0,0,127);
		($logo_w, $logo_h) = $gd_logo->getBounds();

		$gd_logo->interlaced('true');
		$gd_logo->alphaBlending(0);
		$gd_logo->saveAlpha(1);
		$gd_logo->transparent($transparent);
	}


	my $gd_source = GD::Image->new($img_file) or die;
	my ($source_w, $source_h) = $gd_source->getBounds();


        # Determine  target  dimensions  if  not  explicitly
        # defined by command line:
	my $ratio = $source_w / $source_h;
	if (!$target_w && !$target_h)
	{
                # If neither target  width nor target height
                # have  been specified,  keep dimensions  of
                # original image.
		$target_w = $source_w;
		$target_h = $source_h;
	}
	elsif (!$target_w)
	{
                # If target height but  not target width has
                # been  specified,  determine  target  width
                # based  on  height   and  aspect  ratio  of
                # source...
		$target_w = $target_h * $ratio;
	}
	elsif (!$target_h)
	{
		# ... or vice versa.
		$target_h = $target_w / $ratio;
	}


	$gd_source->interlaced('true');
	$gd_source->alphaBlending(0);
	$gd_source->saveAlpha(1);


	my $output_file = GD::Image->new($target_w, $target_h);
	$output_file->interlaced('true');
	$output_file->alphaBlending(0);
	$output_file->saveAlpha(1);


	$output_file->copyResampled(
		$gd_source,
		0,
		0,
		0,
		0,
		$target_w,
		$target_h,
		$source_w,
		$source_h
	);


	if ($logo)
	{
		$output_file->copyMerge(
			$gd_logo,
			$target_w - $logo_w,
			$target_h - $logo_h,
			0,
			0,
			$logo_w,
			$logo_h,
			40
		);
	}


	open(GD, ">output/$img_file") or die;
	binmode GD;
	print GD $output_file->jpeg(80);
	close GD;
}
