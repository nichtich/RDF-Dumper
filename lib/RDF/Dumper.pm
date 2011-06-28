use strict;
use warnings;
package RDF::Dumper;
# ABSTRACT: Dump RDF data objects

use RDF::Trine::Serializer;
use Scalar::Util 'blessed';
use Carp 'croak';

our @ISA = qw(Exporter);
our @EXPORT = qw(rdfdump);

our $SERIALIZER;

sub import {
    my $class = shift;

    @_ = ('turtle') unless @_;
    $RDF::Dumper::SERIALIZER = RDF::Trine::Serializer->new( @_ );

    # Exporter asks for @_
    @_ = ($class,'rdfdump');
    $class->export_to_level(1, @_);
}

sub rdfdump {
    my $serializer;

    if ( blessed $_[0] and $_[0]->isa('RDF::Trine::Serializer') ) {
        $serializer = shift;
    } else {
        $serializer = $RDF::Dumper::SERIALIZER;
    }

    my @serialized = map { _rdfdump( $serializer, $_ ) } @_;

    return join "\n", grep { defined $_ } @serialized;
}

sub _rdfdump {
    my ($ser, $rdf) = @_;

    if ( blessed $rdf ) {
        # RDF::Trine::Serializer should have a more general serialize_ method
        if ( $rdf->isa('RDF::Trine::Model') ) {
            return $ser->serialize_model_to_string( $rdf );
        } elsif ( $rdf->isa('RDF::Trine::Iterator') ) {
            return $ser->serialize_iterator_to_string( $rdf );
        } elsif ( $rdf->isa('RDF::Trine::Statement') ) {
            my $model = RDF::Trine::Model->temporary_model;
            $model->add_statement( $rdf );
            return $ser->serialize_model_to_string( $model );
        } elsif ( $rdf->isa('RDF::Trine::Store') or
                  $rdf->isa('RDF::Trine::Graph') ) {
            $rdf = $rdf->get_statements;
            return $ser->serialize_iterator_to_string( $rdf );
        }
        # TODO: serialize patterns (in Notation3) and single nodes?
    }

    # Sorry, this was no RDF object...

    if ( ref $rdf ) {
        $rdf = "$rdf";
    } elsif ( not defined $rdf ) {
        $rdf = 'undef';
    }

    croak "expected Model/Iterator/Store/Statement/Graph but got $rdf";

    return;
}

1;

=head1 DESCRIPTION

Exports function 'rdfdump' to serialize RDF data objects given as instances of
L<RDF::Trine::Model>, L<RDF::Trine::Iterator>, L<RDF::Trine::Statement>,
L<RDF::Trine::Store>, or L<RDF::Trine::Graph>. See L<RDF::Trine::Serializer>
for details on RDF serializers. By default RDF is serialized as RDF/Turtle.

=head1 SYNOPSIS

  use RDF::Dumper;
  print rdfdump( $rdf_object );

  # configure serializer (as singleton)
  use RDF::Dumper 'rdfxml', namespaces => { ... };

  print rdfdump( $rdf );              # use serializer created on import

  print rdfdump( $serializer, $rdf ); # use another serializer

=cut
