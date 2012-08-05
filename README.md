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

```that_decision
    rdfs:seeAlso <https://github.com/jimregan/caWN-200611-rdf/caWN/wordsense-dietilamida_de_l%27%C3%A0cid_lis%C3%A8rgic-n-1> .
```

If your instinct is that I screwed up somewhere, trust that instinct. 

