use strict;
use warnings;
package RDF::Dumper;
# ABSTRACT: dump RDF data objects

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
    my ($ser, $rdf) = @_;

    unless ( blessed $ser and $ser->isa('RDF::Trine::Serializer') ) {
	    $rdf = $ser;
        $ser = $RDF::Dumper::SERIALIZER;
	}

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
    }

    if ( ref $rdf ) {
        $rdf = "$rdf";
    } elsif ( not defined $rdf ) {
        $rdf = 'undef';
    }

    croak "expected Model/Iterator/Store/Statement/Graph but got $rdf";
}

1;

=head1 DESCRIPTION

Exports function 'rdfdump' to serialize RDF data given as L<RDF::Trine::Model> 
or L<RDF::Trine::Iterator>. See L<RDF::Trine::Serializer> for details.

=head1 SYNOPSIS

  use RDF::Dumper $serializer_name, %options;

  print rdfdump( $rdf );              # use serializer created on import

  print rdfdump( $serializer, $rdf ); # use another serializer

=cut
