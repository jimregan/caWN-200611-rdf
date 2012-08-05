#!/usr/bin/perl

use warnings;
use strict;

use URI::Escape;

open (OUT, ">", "caWN-200611-variant.ttl");
open (LEM, ">", "caWN-200611-variant-lemon.ttl");
open (LNK, ">", "caWN-200611-variant-links.nt");
open (IN, "<", "caWN-200611-variant");

binmode(OUT, ":encoding(utf8)");
binmode(LEM, ":encoding(utf8)");
binmode(IN, ":encoding(latin-1)");

my %possense = ('n' => 'NounWordSense',
		'a' => 'AdjectiveWordSense',
		'v' => 'VerbWordSense',
		'r' => 'AdverbWordSense');

my %possynset = ('n' => 'NounSynset',
		'a' => 'AdjectiveSynset',
		'v' => 'VerbSynset',
		'r' => 'AdverbSynset');

my %poslexvo = ('n' => 'noun',
		'a' => 'adjective',
		'v' => 'verb',
		'r' => 'adverb');

my %posnum = (
	'n' => '1',
	'v' => '2',
	'a' => '3',
	'r' => '4',
);

# Non-dereferenceable URIs make the baby Jesus cry. Or something like that.
# Right about now, I need to walk barefoot through the streets, cap in hand,
# saying "please guv'nor, spare a SPARQL endpoint"
my $base = 'https://github.com/jimregan/caWN-200611-rdf/';
my $inst = "${base}caWN/";
my $leminst = "${base}lemon/";
my $caex = "${base}extra.ttl#";

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
print LEM "<$leminst>\n";
print LEM "    a lemon:Lexicon .\n";
print LEM "\n";

while(<IN>) {
	#...wherein our protagonist generates a _ridiculous_ amount of triples from each individual csv line...

	my ($pos, $synset, $lemma, $sense, $cs, $null) = split/\|/;
	my $ulem = uri_escape_utf8($lemma);
	my $lbl = $lemma =~ s/_/ /g;

	print OUT "inst:synsetid-${posnum{$pos}}${synset}\n";
	print OUT "    a wn20schema:$possynset{$pos} ;\n";
	print OUT "    wn20schema:synsetId \"${posnum{$pos}}${synset}\"^^<xsd:nonNegativeInteger> ;\n";
	print OUT "    wn20schema:containsWordSense <${inst}wordsense-$ulem-$pos-$sense> ;\n";
        print OUT "    caWNextra:confidenceScore \"$cs\"^^<xsd:nonNegativeInteger> .\n";
	print OUT "\n";
	print OUT "<${inst}wordsense-$ulem-$pos-$sense>\n";
	print OUT "    a wn20schema:$possense{$pos} ;\n";
	print OUT "    rdfs:label \"$lemma\"\@ca .\n";
	print OUT "\n";

	print LEM "<$leminst>\n";
	print LEM "    lemon:entry <${leminst}$ulem-$poslexvo{$pos}> .\n";
	print LEM "\n";
	print LEM "<${leminst}$ulem-$pos-$sense>\n";
	print LEM "    lemon:reference cawninst:synsetid-${posnum{$pos}}${synset} .\n";
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
	print LEM "<$leminst>\n";
	print LEM "    lemon:entry <${leminst}$ulem-$poslexvo{$pos}> .\n";
	print LEM "\n";

	print LNK "<${inst}wordsense-$ulem-$pos-$sense> <http://www.w3.org/2002/07/owl#sameAs> <${leminst}$ulem-$pos-$sense> .\n";
}
