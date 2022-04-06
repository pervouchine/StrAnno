#!/usr/bin/perl
# Create bed9 file with structural annotation
# track.pl classes.tsv palette.tsv < mapping.bed > stranno.bed9

($classes, $palette, $outdir) = @ARGV;

open FILE, $palette;
while($line=<FILE>) {
    chomp $line;
    ($class, $label, $color) = split /\t/, $line;
    $color{$label} = $color;
}
close FILE;

print STDERR "[$classes";
open FILE, "$classes" || die("cannot find structural annotation file");
while($line=<FILE>) {
    chomp $line;
    ($key, $class, $ref) = split /\t/, $line;
    $stranno{$key} = $class;
    $ref{$key} = $ref;
}
close FILE;
print STDERR "]\n";

print STDERR "[mapping";
while($line=<STDIN>) {
    chomp $line;
    ($chr, $beg, $end, $name, $score, $str, $keys) = split /\t/, $line;
    foreach $key(split /\,/, $keys) {
    	next unless($class = $stranno{$key});
	$ref = $ref{$key};
	$id = join("\t", $chr, $beg, $end, $ref, $str);
	$hash{$class}{$id}++
    }
}
print STDERR "]\n";


foreach $class(keys(%hash)) {
    $color = $color{$class};
    $chr0 = $beg0 = $end0 = $ref0 = $str0 = undef;
    print STDERR "[>$outdir$class.bed $color";
    open FILE, ">$outdir$class.bed";
    foreach $id(sort keys(%{$hash{$class}})) {
	($chr, $beg, $end, $ref, $str) = split /\t/, $id;
	if($chr eq $chr0 && $str eq $str0 && $ref == $ref0 && $beg == $end0) {
            $end0 = $end;
    	}
    	else {
            print FILE join("\t", $chr0, $beg0, $end0, $ref, 1000, $str0), "\n" if($chr0);
            ($chr0, $beg0, $end0, $ref0, $str0) = ($chr, $beg, $end, $ref, $str);
	}
    }
    print FILE join("\t", $chr0, $beg0, $end0, $class, 1000, $str0), "\n" if($chr0);
    close FILE;
    print "$class\n";
    print STDERR "]\n";
}
