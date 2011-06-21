use strict;
use warnings;
package RDF::Dumper;
# ABSTRACT: dump RDF data

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
    my $rdf = shift;

    if ( blessed $rdf ) {
        # RDF::Trine::Serializer should have a more general serialize_ method
        if ( $rdf->isa('RDF::Trine::Model') ) {
            return $RDF::Dumper::SERIALIZER->serialize_model_to_string( $rdf );
        } elsif ( $rdf->isa('RDF::Trine::Iterator') ) {
            return $RDF::Dumper::SERIALIZER->serialize_iterator_to_string( $rdf );
        }
    }

    if ( ref $rdf ) {
        $rdf = "$rdf";
    } elsif ( not defined $rdf ) {
        $rdf = 'undef';
    }

    croak "expected RDF::Trine::(Model|Iterator), got $rdf";
}

1;

=head1 DESCRIPTION

Exports function 'rdfdump' to serialize RDF data given as L<RDF::Trine::Model> 
or L<RDF::Trine::Iterator>. See L<RDF::Trine::Serializer> for details.

=head1 SYNOPSIS

  use RDF::Dumper $serializer_name, %options;

  print rdfdump( $rdf )

=cut
