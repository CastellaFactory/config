#!/usr/bin/env perl

$latex          = 'platex -synctex=1 %O %S';
$bibtex         = 'pbibtex %O %B';
$dvipdf         = 'dvipdfmx %O -o %D %S';
$max_repeat     = 5;
$pdf_mode       = 3;

if ($^O eq 'darwin') {
    $pdf_previewer      = 'open -ga /Applications/Skim.app';
} else {
    $pdf_previewer      = !`which okular >/dev/null 2>&1`?
                            'okular' : !`which evince > /dev/null 2>&1`? 'evince' : 'xdg-open';
}

# vim: set expandtab ts< sw=4 sts=4:
