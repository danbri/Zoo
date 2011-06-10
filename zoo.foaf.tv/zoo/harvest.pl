#!/usr/bin/perl
#
# Script to fetch schemas that will be represented (in part) in the Zoo
# Dan Brickley <danbri@danbri.org>

open(IN,"master.txt") || die "No input data.";
while(<IN>) {
  chomp;
  if (m/^#/){next;}
  my ($prefix, $uri, $tag, $comment) = split(/\t/,$_,4);
  # print "PREFIX: $prefix URI: $uri TAG: $tag COMMENT: $comment\n";

  # Fixed!! if ($uri =~ m/bibo/) { $uri = 'http://bibotools.googlecode.com/svn/bibo-ontology/tags/1.3/bibo.xml.owl'; }  # trouble with bibo: PURL (reported...)

  if ($tag =~ m/zoo/) {
   if ($tag =~ m/rdfa/) {
    `curl -L $uri > data/$prefix.rdfa`;
    `rapper -i rdfa -o rdfxml data/$prefix.rdfa > data/$prefix.rdf`;
   } else { 
    `curl -L -H "Accept: application/rdf+xml" $uri > data/$prefix.rdf`;
   }
  } # skip things not in the Zoo yet.
}

# Quality check:
#
# find data/ -name \*.rdf -exec rapper  --count {} \;  2>&1 | grep 'triples'

