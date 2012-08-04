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

my %posnum = (
	'n' => '1',
	'v' => '2',
	'a' => '3',
	'r' => '4',
);

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
	} elsif ($rel eq 'near_antonym') {
		$pred = 'caWNextra:nearAntonymOf';
	} elsif ($rel eq 'near_synonym') {
		$pred = 'caWNextra:nearSynonymOf';
	} elsif ($rel eq 'xpos_near_synonym') {
		$pred = 'caWNextra:xposNearSynonymOf';
	} elsif ($rel eq 'role_agent') {
		$pred = 'caWNextra:roleAgent';
	} elsif ($rel eq 'has_hyponym') {
		$pred = 'wn20schema:hyponymOf';
	} elsif ($rel eq 'has_xpos_hyponym') {
		$pred = 'caWNextra:xposHyponymOf';
	} elsif ($rel eq 'be_in_state') {
		$pred = 'caWNextra:inState';
	} elsif ($rel eq 'has_holo_part') {
		$pred = 'wn20schema:partMeronymOf';
	} elsif ($rel eq 'has_holo_member') {
		$pred = 'wn20schema:memberHolonymOf';
	} elsif ($rel eq 'has_holo_madeof') {
		$pred = 'wn20schema:substanceMeronymOf';
	} elsif ($rel eq 'verb_group') {
		$pred = 'wn20schema:sameVerbGroupAs';
	} elsif ($rel eq 'has_subevent') {
		$pred = 'caWNextra:hasSubevent';
	} else {
		if (!$seen{"$rel $poss $poso"}) {
			print STDERR "$rel $poss $poso\n";
			$seen{"$rel $poss $poso"} = 1;
		}
	}
	if (!$pred || $pred eq '') {
		print STDERR "$rel $poss $poso\n";
	}

	print OUT "inst:synsetid-${posnum{$poss}}${ssets}\n";
	print OUT "    $pred inst:synsetid-${posnum{$poso}}${sseto} .\n" if ($pred ne '');
	print OUT "\n";
}

