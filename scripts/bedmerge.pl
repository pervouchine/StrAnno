while($line=<STDIN>) {
    chomp $line;
    ($chr, $beg, $end, $name, $x, $str, $x, $x, $col) = split /\t/, $line;
    if($chr eq $chr0 && $name eq $name0 && $str eq $str0 && $beg == $end0) {
	$end0 = $end;
    }
    else {
	print join("\t", $chr0, $beg0, $end0, $name0, 1000, $str0, $beg0, $end0, $col0), "\n" if($chr0);
	($chr0, $beg0, $end0, $name0, $str0, $col0) = ($chr, $beg, $end, $name, $str, $col);
    }
}
print join("\t", $chr0, $beg0, $end0, $name0, 1000, $str0, $beg0, $end0, $col0), "\n";	

