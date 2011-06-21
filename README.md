RDF::Dumper is a Perl module to stringify RDF data objects in readable form.
Actually it is just a handy wrapper on RDF::Trine::Serializer.

Usage
-----
Dump instances of RDF::Trine::Model and similar objects in RDF/Turtle:

    use RDF::Dumper;
	print rdfdump( $rdf );

An alternative serialization format can be created on import:

    use RDF::Dumper 'rdfxml', namespaces => { ... };

Strings with RDF in some serialization are not considered as RDF data objects.

