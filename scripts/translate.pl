#!/usr/bin/perl
# Translates transcripts to protein
# translate.pl exon_sequences.tsv genetic_code.tsv < bed6+1 exons.bed > out.tsv
($seq_file, $genetic_code) = @ARGV;

%seq = split /[\t\n]/, `cat $seq_file`;
%genetic_code = split /[\t\n]/, `cat $genetic_code`;

while($line=<STDIN>) {
    chomp $line;
    ($chr, $beg, $end, $name, $score, $str, $transcript) = split /\t/, $line;
    push @{$exons{$transcript}}, [$chr, $beg, $end, $str];
}

foreach $transcript(keys(%exons)) {
    @pos = sort {$a->[1]<=>$b->[1]} @{$exons{$transcript}};
    @pos = reverse @pos if($pos[0]->[3] eq "-");
    $flag = T;
    $res = undef;
    for($i=0;$i<@pos;$i++) {
        $id = join("_",@{$pos[$i]});
        $flag = F unless($seq{$id}=~/\w/);
        $res.=$seq{$id};
    }
    $res =~ tr/[a-z]/[A-Z]/;
    print STDERR "[WARNING: exon not found in $t]\n" unless($flag);
    ($transcript) = split /\./, $transcript;
    $protein = translate($res);
    $protein =~ s/\*$//;
    print join("\t", $transcript, $protein), "\n";
}

sub translate {
    my @a = split //, @_[0];
    my $res = undef;
    for(my $i=0;$i<@a;$i+=3) {
	last if(@a-$i<3);
	my $codon = join("",$a[$i],$a[$i+1],$a[$i+2]);
        my $x = $genetic_code{$codon};
        $res.= ($x=~/[\w\*]/ ? $x : "!");
    }
    return($res);
}


