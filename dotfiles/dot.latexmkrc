#!/usr/bin/env perl

$latex          = 'platex -synctex=1 %O %S';
$bibtex         = 'pbibtex %O %B';
$dvipdf         = 'dvipdfmx %O -o %D %S';
$max_repeat     = 5;
$pdf_mode       = 3;

$pvc_view_file_via_temporary    = 0;

if ($^O eq 'darwin') {
    $pdf_previewer      = 'open -ga /Applications/Skim.app';
} else {
    $pdf_previewer      = 'xdg-open';
}

# vim: set expandtab ts< sw=4 sts=4:
