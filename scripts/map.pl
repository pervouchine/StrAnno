#!/usr/bin/perl
# Map annotation positions to the genome
# map.pl annot.bed positions.tsv < uniprot_map.tsv > mapping.bed

($annot, $positions) = @ARGV;
print STDERR "[$annot";
open FILE, "$annot";
while($line=<FILE>) {
    chomp $line;
    ($chr, $beg, $end, $name, $score, $str, $transcript) = split /\t/, $line;
    ($transcript) = split /\./, $transcript;
    push @{$exons{$transcript}}, [$chr, $beg, $end, $str];
}
print STDERR "]\n";

print STDERR "[$positions";
open FILE, "$positions" || die("cannot find structural annotation");
while($line=<FILE>) {
    chomp $line;
    ($uid, $aa, $pos) = split /\t/, $line;
    $aa{$uid}[$pos]=$aa;
}
close FILE;
print STDERR "]\n";

while($line=<STDIN>) {
    chomp $line;
    ($uid, $transcript_id) = split /\t/, $line;
    next unless($exons{$transcript_id});
    @pos = sort {$a->[1]<=>$b->[1]} @{$exons{$transcript_id}};
    $strand = $pos[0]->[3];
    @pos = reverse @pos if($strand eq "-");
    $k = 1;
    for($i = 0;$i < @pos; $i++) {
	if($strand eq "+") {
	    for($j = $pos[$i]->[1]; $j <= $pos[$i]->[2]; $j++) {
		$p = int(($k-1)/3)+1;
		$id = join("\t",$pos[$i]->[0],$j-1,$j,".",1000, $pos[$i]->[3]);
		push @{$res{$id}}, "$uid:$p:$aa{$uid}[$p]" if($aa{$uid}[$p]);
		$k++;
	    }
	}
	else {
	    for($j = $pos[$i]->[2]; $j >= $pos[$i]->[1]; $j--) {
		$p = int(($k-1)/3)+1;
		$id = join("\t",$pos[$i]->[0],$j-1,$j,".",1000, $pos[$i]->[3]);
                push @{$res{$id}}, "$uid:$p:$aa{$uid}[$p]" if($aa{$uid}[$p]);
		$k++;
	    }
	}
    }
}

foreach $id(sort keys(%res)) {
    print join("\t", $id, join(",", sort @{$res{$id}})), "\n";

}
