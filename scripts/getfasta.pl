#!/usr/bin/perl
# Extract regions from the genome according to 0-bed input
# getfasta.pl genome_fasta_file.fa < bed_input.bed > tsv_output.tsv

open FILE, $ARGV[0] || die("Genome fasta file $ARGV[0] not found");
while($line=<FILE>) {
    chomp $line;
    if($line=~/^>/) {
	$seq{$ref} = $s if($ref);
	$ref = substr($line, 1);
	$s = undef;
	print STDERR "[$ref]\n";
    }
    else {
	$s.=$line;
    }
}
$seq{$ref} = $s if($ref);

#foreach $ref(keys(%seq)) {
#    next if(substr($ref, "_")<0);
#    print STDERR join("\t", $ref, length($seq{$ref})), "\n";
#}

while($line=<STDIN>) {
    chomp $line;
    ($chr, $beg, $end, $name, $score, $str) = split /\t/, $line;
    $s = substr($seq{$chr}, $beg, $end-$beg);
    die("sequence lengths not match on $chr:$beg-$end") unless(length($s)==$end-$beg);
    print join("\t", $name, $str eq "+" ? $s : rc($s)), "\n";
}

sub rc {
    my $x = @_[0];
    $x =~ tr/[a-z]/[A-Z]/;
    $x =~ tr/ACGT/TGCA/;
    return(join(undef, reverse split //,$x));
}







