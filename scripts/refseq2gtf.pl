#!/usr/bin/perl
# This script converts a RefSeq annotation file to a GTF
# refseq2gtf.pl < RefSeq.tsv > RefSeq.gtf

while($line=<STDIN>) {
    chomp $line;
    ($x, $refid, $chr, $str, $start, $end, $cds_start, $cds_end, $n, $exon_starts, $exon_ends, $x, $x, $gid) = split /\t/, $line;
    $refid =~ s/\_//g;
    $attr = 'gene_type "protein_coding"; transcript_type "protein_coding"; ';
    $attr.= "gene_id \"$refid\"; transcript_id \"$refid\";";

    @starts = split /\,/, $exon_starts;
    @ends = split /\,/, $exon_ends;

    $k = 0;
    for($i=0; $i<$n; $i++) {
	$a = $cds_start > $starts[$i] ? $cds_start : $starts[$i];
	$b = $cds_end < $ends[$i] ? $cds_end : $ends[$i];
	next unless($a < $b);
	print join("\t", $chr, "REFSEQ", "CDS", $a + 1, $b, ".", $str, 0, $attr), "\n";
	$k++;
    }
    print join("\t", $chr, "REFSEQ", "transcript", $start + 1, $end, ".", $str, 0, $attr), "\n" if($k>0);
}
