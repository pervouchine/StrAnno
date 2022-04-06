#!/usr/bin/perl
# Read proteome classes and extract protein sequences
# extract_protein_seq.pl < proteome.classification.tsv > proteome.tsv
while($line=<STDIN>) {
    ($id, $x, $x, $x, $x, $aa, $pos) = split /\t/, $line;
    $seq{$id}[$pos]=$aa;
}
foreach $id(sort keys(%seq)) {
    for($i=1;$i<@{$seq{$id}};$i++) {
	$seq{$id}[$i] = 'Z' unless($seq{$id}[$i]);
    }
    print $id, "\t", join("", @{$seq{$id}}), "\n";
}
