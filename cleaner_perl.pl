#!/usr/bin/perl

use strict;
use warnings;
use File::MimeInfo;

my $downloads_dir = $ARGV[0];

# File types and their corresponding directories
my %file_types = (
    'video'    => 'a_video',
    'audio'    => 'a_music',
    'image'    => 'a_image',
    'archive'  => 'a_archive',
    'document' => 'a_document',
    'application/pdf' => 'a_document',
    'application/msword' => 'a_document',

    'application/vnd.oasis.opendocument.text' => 'a_document',
    'application/vnd.oasis.opendocument.spreadsheet' => 'a_document',
    'application/vnd.oasis.opendocument.presentation' => 'a_document',
    'application/vnd.oasis.opendocument.graphics' => 'a_document',
    'application/vnd.oasis.opendocument.chart' => 'a_document',
    'application/vnd.oasis.opendocument.image' => 'a_document',
    'application/vnd.oasis.opendocument.formula' => 'a_document',
    'application/vnd.oasis.opendocument.text-master' => 'a_document',
    'application/vnd.oasis.opendocument.text-web' => 'a_document',
    'application/vnd.oasis.opendocument.text-template' => 'a_document',
    'application/vnd.oasis.opendocument.spreadsheet-template' => 'a_document',
    'application/vnd.oasis.opendocument.presentation-template' => 'a_document',
    'application/vnd.oasis.opendocument.graphics-template' => 'a_document',
    'application/vnd.oasis.opendocument.chart-template' => 'a_document',
    'application/vnd.oasis.opendocument.image-template' => 'a_document',
    'application/vnd.oasis.opendocument.formula-template' => 'a_document',
    'application/vnd.oasis.opendocument.text-master-template' => 'a_document',
    'application/vnd.oasis.opendocument.text-web-template' => 'a_document',

    'application/x-cd-image' => 'a_archive',
    'application/zip' => 'a_archive',
    'application/gzip' => 'a_archive',
    'application/x-bzip2' => 'a_archive',
    'application/x-rar' => 'a_archive',
    'application/x-7z-compressed' => 'a_archive',
    'application/x-tar' => 'a_archive',
    'application/x-iso9660-image' => 'a_archive',
    'application/x-lha' => 'a_archive',
    'application/x-lhz' => 'a_archive',
    'application/x-lzma' => 'a_archive',
    'application/x-lzma-compressed-tar' => 'a_archive',
    'application/x-lzop' => 'a_archive',

    'application/vnd.debian.binary-package' => 'a_archive',
    'application/x-deb' => 'a_archive',
    'application/x-rpm' => 'a_archive',
    'application/x-rar-compressed' => 'a_archive',
    
    'application/application/x-compressed-tar' => 'a_archive',

    #MS Office documents
    'application/vnd.ms-excel' => 'a_document',
    'application/vnd.ms-powerpoint' => 'a_document',    
    'application/vnd.ms-word' => 'a_document',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'a_document',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'a_document',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'a_document',

);

unless (-d $downloads_dir) {
    die "Downloads directory not found: $downloads_dir\n";
}

foreach my $file (glob("$downloads_dir/*")) {
    next unless -f $file;  # Skip if not a regular file

    my $mime_type = mimetype($file);

    if (defined $mime_type) {
        my $category = 'a_other';

        # Determine the category for the file
        foreach my $type (keys %file_types) {
            if ($mime_type =~ /^$type/) {
                $category = $file_types{$type};
                last;
            }
        }

        my $destination_dir = "$downloads_dir/$category";

        unless (-d $destination_dir) {
            mkdir $destination_dir or die "Failed to create directory: $destination_dir - $!\n";
        }

        my $new_file = "$destination_dir/" . (split('/', $file))[-1];

        rename($file, $new_file) or die "Failed to move file: $file - $!\n";
        print "Moved: $file to $new_file\n";
    }
}

print "File organization complete.\n";


