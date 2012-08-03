#!/usr/bin/perl

use warnings;
use strict;

use URI::Escape;

open (OUT, ">", "caWN-200611-variant.ttl");
open (LEM, ">", "caWN-200611-variant-lemon.ttl");
open (IN, "<", "caWN-200611-variant");

binmode(OUT, ":encoding(utf8)");
binmode(LEM, ":encoding(utf8)");
binmode(IN, ":encoding(latin-1)");

my %possense = ('n' => 'NounWordSense',
		'a' => 'AdjectiveWordSense',
		'v' => 'VerbWordSense');

my %possynset = ('n' => 'NounSynset',
		'a' => 'AdjectiveSynset',
		'v' => 'VerbSynset');

my %poslexvo = ('n' => 'noun',
		'a' => 'adjective',
		'v' => 'verb');

my $inst = 'file:/foo/';
my $leminst = 'file:/baz/';
my $caex = 'file:/bar/';

print OUT "\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print OUT "\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n";
print OUT "\@prefix wn20instances: <http://www.w3.org/2006/03/wn/wn20/instances/> .\n";
print OUT "\@prefix wn20schema: <http://www.w3.org/2006/03/wn/wn20/schema/> .\n";
print OUT "\@prefix caWNextra: <$caex> .\n";
print OUT "\@prefix inst: <$inst> .\n";
print OUT "\n";

print LEM "\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print LEM "\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n";
print LEM "\@prefix lexinfo: <http://www.lexinfo.net/ontology/2.0/lexinfo#> .\n";
print LEM "\@prefix lemon: <http://www.monnet-project.eu/lemon#> .\n";
print LEM "\@prefix inst: <$leminst> .\n";
print LEM "\@prefix cawninst: <$inst> .\n";
print LEM "\n";

while(<IN>) {
	my ($pos, $synset, $lemma, $sense, $cs, $null) = split/\|/;
	my $ulem = uri_escape_utf8($lemma);
	my $lbl = $lemma =~ s/_/ /g;

	print OUT "inst:synsetid-$synset\n";
	print OUT "    a wn20schema:$possynset{$pos} ;\n";
	print OUT "    wn20schema:synsetId \"$synset\"^^<xsd:nonNegativeInteger> ;\n";
	print OUT "    wn20schema:containsWordSense <${inst}wordsense-$ulem-$pos-$sense> ;\n";
        print OUT "    caWNextra:confidenceScore \"$cs\"^^<xsd:nonNegativeInteger> .\n";
	print OUT "\n";
	print OUT "<${inst}wordsense-$ulem-$pos-$sense>\n";
	print OUT "    a wn20schema:$possense{$pos} ;\n";
	print OUT "    rdfs:label \"$lemma\"\@ca .\n";
	print OUT "\n";


	print LEM "<${leminst}$ulem-$pos-$sense>\n";
	print LEM "    lemon:reference cawninst:synsetid-$synset .\n";
	print LEM "\n";
	print LEM "<${leminst}word-$ulem-canonicalForm>\n";
	print LEM "    lemon:writtenRep \"$lemma\"\@ca .\n";
	print LEM "\n";
	print LEM "<${leminst}$ulem-$poslexvo{$pos}>\n";
	print LEM "    a lemon:LexicalEntry ;\n";
	print LEM "    lemon:sense <${leminst}$ulem-$pos-$sense> ;\n";
	print LEM "    lemon:canonicalForm <${leminst}word-$ulem-canonicalForm> ;\n";
	print LEM "    lexinfo:partOfSpeech lexinfo:$poslexvo{$pos} .\n";
	print LEM "\n";
}
