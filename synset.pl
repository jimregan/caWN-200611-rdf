#!/usr/bin/perl

use warnings;
use strict;

use URI::Escape;

open (OUT, ">", "caWN-200611-synset.ttl");
open (IN, "<", "caWN-200611-synset");

binmode(OUT, ":encoding(utf8)");
binmode(IN, ":encoding(latin-1)");

my $base = 'https://github.com/jimregan/caWN-200611-rdf/';
my $inst = "${base}caWN/";
my $caex = '${inst}extra.ttl';

print OUT "\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print OUT "\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n";
print OUT "\@prefix wn20instances: <http://www.w3.org/2006/03/wn/wn20/instances/> .\n";
print OUT "\@prefix wn20schema: <http://www.w3.org/2006/03/wn/wn20/schema/> .\n";
print OUT "\@prefix caWNextra: <$caex> .\n";
print OUT "\@prefix inst: <$inst> .\n";
print OUT "\n";

while(<IN>) {
	chomp;
	my ($pos, $synset, $numhyp, $stat, $def) = split/\|/;
	my ($ver, $inca) = split(//, $stat);
	$def =~ s/"/\\"/g;

	print OUT "inst:synsetid-$synset\n";
        print OUT "    caWNextra:humanVerified \"true\"^^<xsd:boolean> ;\n" if ($ver eq 'i');
        print OUT "    caWNextra:noCatalanLexicalForm \"true\"^^<xsd:boolean> ;\n" if ($inca eq 'n');
	print OUT "    wn20schema:gloss \"$def\" ;\n" if ($def ne '' && $def ne '\N');
	print OUT "    caWNextra:hyponymCount \"$numhyp\"^^<xsd:nonNegativeInteger> .\n";
	print OUT "\n";
}
