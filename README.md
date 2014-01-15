RDF::Dumper is a Perl module to stringify RDF data objects in readable form,
which is handy for debugging and logging. Actually, the module is just a handy 
wrapper on RDF::Trine::Serializer. You can use it like this:

    use RDF::Dumper;
    print rdfdump( $rdf_object );

    # configure serializer (as singleton)
    use RDF::Dumper 'rdfxml', namespaces => { ... };

    print rdfdump( $rdf );               # use serializer created on import

    print rdfdump( $serializer, $rdf );  # use another serializer

By the way, strings with RDF in some serialization are not considered as RDF 
data objects, but strings that first need to be parsed to get RDF data.

Feel free to submit patches, comments, and issues and/or fork this module at
https://github.com/nichtich/RDF-Dumper

# Status

[![Build Status](https://travis-ci.org/gbv/RDF-Dumper.png)](https://travis-ci.org/gbv/RDF-Dumper)
[![Coverage Status](https://coveralls.io/repos/gbv/RDF-Dumper/badge.png?branch=devel)](https://coveralls.io/r/gbv/RDF-Dumper)
[![Kwalitee Score](http://cpants.cpanauthors.org/dist/RDF-Dumper.png)](http://cpants.cpanauthors.org/dist/RDF-Dumper)
