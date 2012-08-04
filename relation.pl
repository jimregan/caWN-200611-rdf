#!/usr/bin/perl

use warnings;
use strict;

use URI::Escape;

open (OUT, ">", "caWN-200611-relation.ttl");
open (IN, "<", "caWN-200611-relation");

binmode(OUT, ":encoding(utf8)");
binmode(IN, ":encoding(latin-1)");

my $base = 'https://github.com/jimregan/caWN-200611-rdf/';
my $inst = "${base}caWN/";
my $caex = "${base}extra.ttl#";

print OUT "\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print OUT "\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n";
print OUT "\@prefix wn20instances: <http://www.w3.org/2006/03/wn/wn20/instances/> .\n";
print OUT "\@prefix wn20schema: <http://www.w3.org/2006/03/wn/wn20/schema/> .\n";
print OUT "\@prefix caWNextra: <$caex> .\n";
print OUT "\@prefix inst: <$inst> .\n";
print OUT "\n";

my %seen;

while(<IN>) {
	chomp;
	my ($rel, $poss, $ssets, $poso, $sseto, $conf) = split/\|/; #/
	my $pred;

	if ($rel eq 'pertains_to' && $poss eq 'a' && $poso eq 'n') {
		$pred = 'caWNextra:adjectivePertainsTo';
	} elsif ($rel eq 'causes' && $poss eq 'v' && $poso eq 'v') {
		$pred = 'wn20schema:causes';
	} elsif ($rel eq 'causes' && $poss eq 'n' && $poso eq 'a') {
		$pred = 'caWNextra:nounCausesAdjective';
	} elsif ($rel eq 'causes' && $poss eq 'n' && $poso eq 'n') {
		$pred = 'caWNextra:nounCausesNoun';
	} elsif ($rel eq 'causes' && $poss eq 'a' && $poso eq 'n') {
		$pred = 'caWNextra:adjectiveCausesNoun';
	} elsif ($rel eq 'see_also_wn15') {
		$pred = 'rdfs:seeAlso';
	} elsif ($rel eq 'has_derived') {
		$pred = 'caWNextra:hasDerivedSynset';
	} else {
		if (!$seen{"$rel $poss $poso"}) {
			print STDERR "$rel $poss $poso\n";
			$seen{"$rel $poss $poso"} = 1;
		}
	}

#	print OUT "inst:synsetid-$ssets\n";
#	print OUT "    caWNextra:humanVerified \"true\"^^<xsd:boolean> ;\n" if ($ver eq 'i');
#	print OUT "    caWNextra:noCatalanLexicalForm \"true\"^^<xsd:boolean> ;\n" if ($inca eq 'n');
#	print OUT "    wn20schema:gloss \"$def\" ;\n" if ($def ne '' && $def ne '\N');
#	print OUT "    caWNextra:hyponymCount \"$numhyp\"^^<xsd:nonNegativeInteger> .\n";
#	print OUT "\n";
}


xpos_near_synonym n a
xpos_near_synonym a n
role_agent n n
near_synonym a a
near_antonym a a
has_xpos_hyponym n a
has_hyponym v v
has_hyponym n n
be_in_state n a
has_holo_part n n
has_holo_member n n
near_antonym n n
has_holo_madeof n n
near_antonym r r
has_subevent v v
near_antonym v v
verb_group v v

