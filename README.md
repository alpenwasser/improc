improc - Perl Bulk Image Processing Script
==========================================

Capabilities
------------

Takes one or multiple images as input arguments (or a directory)
and applies certain processing steps to the image(s).

Specifically:

- A logo image can be specified and  will be overlaid over each image as it is
processed. The logo will be appropriately resized according to output image(s)
size. Some slight  transparency will  be applied  to the logo  and it  will be
placed in the lower left corner.
-  Width and  height  of output  image(s)  can be  specified. If  only one  is
specified, the other will be adjusted  accordingly so that the aspect ratio of
the image  stays intact. If both are  specified, the aspect ratio  will not be
protected from change. If neither width nor height are speciied, they will be
taken from the input file (they might still be changed due to trim though).
-  Trimming: Top, right,  bottom and  left side  can be  trimmed according  to
specified trim factors  (between 0 and 1). Useful when  converting images from
4:3 to 3:2, for example.
- Various  input and output  formats: GIF, PNG  and JPEG are  supported.  Note
that transparent areas from input GIF or PNG images will be converted to black
when specifying JPEG as output format. Animated GIFs are not supported at this
point.


Input Flags
-----------

- `--logo|-l <filepath>`: Path to logo image. Optional. Must also be png, jpeg
    or gif.
- `--width|-w <pixel count>`: Pixel count for width of output files. Optional.
    Will default to width of input file.
- `--height|-h   <pixel   count>`: Pixel   count  for   height   of   output
    files. Optional. Will default to height of input file.
- `--files|-f  <files|directory>`: list of  filenames or a directory  of input
    images to process.
-  `--trim|-t <top>  <right> <bottom>  <left>`: Trim factors  for top,  right,
    bottom and left side. Must be numbers  between 0 and 1. Note that opposing
    sides can not be trimmed above a sum  total of 1, as then the entire image
    would be gone (example: trimming half of the image on the left and half on
    the right side would result in no image). If less than four arguments have
    been  specified, the  remaining  ones  will be  assumed  0,  in the  order
    specified above. If too  many are specified, the superfluous  ones will be
    discarded.  If the sum total of two  opposing trim factors is above 1, the
    program will abort.
-  `--overwrite|-w`: When doing  multiple  runs (maybe  to  play around  until
    optimal results  are reached), specify  whether or not to  overwrite files
    from previous  runs or not. Default  is off  (so, old files  from previous
    runs  will be  preserved and  new  ones saved  under numerically  iterated
    filenames). Optional.
- `--output_format|-of <jpeg|jpg|png|gif>`: Output file format. Optional. Will
    default to input file format.


Useful Notes
------------

### Trim From 4:3 to 3:2

Since  a 4:3  image is  taller in  relation  to its  width than  a 3:2  image,
trimming off trom top and/or bottom is required, approximately 11.11% in total
to be specific.  So, an example could look like this:

> improc -f <input file> --trim 0.0555 0 0.0555 0

This will  trim 5.55%  off the top  and bottom, respectively,  for a  total of
approximately 11.11%. Adjust  numbers accordingly if  you do not wish  to trim
symmetrically, of course.


### Trim from 3:2 to 4:3

Going from 3:2 to 4:3, we need to trim approximately 10.96% in width instead
of height. So a symmetrical trim would look like this:

> improc -f <input file> --trim 0 0.0548 0 0.0548

### Trimming and Output File Dimensions

The  output file  dimensions will  be appliet  *after* the  trimming has  been
done. So  the output  file dimensions will indeed be what  has been specified,
unaffected by the trimming.


Output Files
------------

A directory  "output" will be  created in  the current working  directory, and
output files will be placed there.


Examples
--------

Take all png, jpeg|jpg and gif files in `input_directory` and convert them
to jpeg files of width 600 pixels, overlaid with `logo_file.png`:

> improc --file input\_directory --logo logo\_file.png -output\_format jpeg -w 600

or:

> improc -f input\_directory -l logo\_file.png -of jpeg -w 600

Convert one jpeg  input file to a  jpeg output file, trimming 33%  off the top
and making the  target image 600px high. Note that trimming  does not decrease
the output file's height, as mentioned above.

> improc -f input_file.png -t 0.33 0 0 0 -of 600


Issues
------

- When a log  with transparent areas is used, the edges  between the solid and
    the transparent areas are sometimes rather ugly in the output file. I have
    so far been unable to fix this, and suspect it is a GD limitation (if that
    is incorrect and somebody knows a way  to fix this, feel free to notify me
    or do it yourself).

- When resizing portrait images, the logo will be placed in the incorrect
    corner of the image (top right).
