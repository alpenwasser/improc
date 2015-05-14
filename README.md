improc - Perl Bulk Image Processing Script
==========================================

Capabilities
------------

Takes one or multiple images as input arguments (or a directory)
and applies certain processing steps to the image(s).

Specifically:

- A logo image can be specified and  will be overlaid over each image as it is
processed. The logo will be appropriately resized according to output image(s)
size.
-  Width and  height  of output  image(s)  can be  specified. If  only one  is
specified, the other will be adjusted  accordingly so that the aspect ratio of
the image  stays intact. If both are  specified, the aspect ratio  will not be
protected from change.
-  Trimming: Top, right,  bottom and  left side  can be  trimmed according  to
specified trim factors  (between 0 and 1). Useful when  converting images from
4:3 to 3:2, for example.
- Various  input and output  formats: GIF, PNG  and JPEG are  supported.  Note
that transparent areas from input GIF or PNG images will be converted to black
when specifying JPEG as output format. Animated GIFs are not supported at this
point.


		"logo|l=s"           => \$LOGO,
		"width|w=i"          => \$DESIRED_W,
		"height|h=i"         => \$DESIRED_H,
		"files|f=s{,}"       => \@SOURCE_FILES,
		"trim|t=s{,}"        => \@TRIM,
		"overwrite|o!"       => \$OVERWRITE,
		"output_format|of=s" => \$OUTPUT_FORMAT
