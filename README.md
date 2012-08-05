caWN-200611-rdf
===============

tl;dr: RDF conversion of Catalan WordNet

tl:

Some caveats:

The URIs in the current version are temporary. If/when I find hosting where
all of those nice things - dereferencable URIs, SPARQL endpoint - are 
possible, I'll rework the data to reflect where it'll live. But they'll do for
now.

caWN is based on EuroWordNet, which means there are some remnants of truly
weird design decisions. The one that springs to mind first is that 
derivational relationships are at the _synset_ level, not the lexical level.
If you know what a synset is, you'll know why that's weird. (And if you don't,
you've probably taken a wrong turn somewhere.) To put it in pseudo-RDF:

```
that_decision
    rdfs:seeAlso <https://github.com/jimregan/caWN-200611-rdf/caWN/wordsense-dietilamida_de_l%27%C3%A0cid_lis%C3%A8rgic-n-1> .
```

If your instinct is that I screwed up somewhere, trust that instinct. 

Catalan WordNet follows the EuroWordNet model; in essence, this means that
it attaches Catalan WordSense entries to Princeton's Synsets. As there
is no RDF conversion of WordNet 1.6, I've used UPC's mappings between WordNet
1.6 and 2.0. I used only alignments with a confidence score of '1'. In 
theory, the relations in Princeton WordNet (in the W3C's RDF conversion)
should apply to caWN, and, conversely, that the extra relations present in
caWN should apply to Princeton WordNet. 

Given:
```
inst:synset-osseous-adjective-1 
    owl:sameAs cainst:synsetid-302871410 .

inst:synset-osseous-adjective-1
    wnschema:containsWordSense inst:wordsense-bony-adjective-2, inst:wordsense-osseous-adjective-1, inst:wordsense-osteal-adjective-2 .

inst:synsetid-302871410 
    wnschema:containsWordSense cainst:wordsense-ossi-a-1 .
```

and a quick check:

```
$ echo ossi|apertium ca-en
Osseous
```

it seems to work out in practice.

In addition to a conversion using the W3C model, there is a conversion that
follows the Lemon model. This is probably the version you want to use - at
the very least, it uses a more general set of terms for part of speech, etc.

