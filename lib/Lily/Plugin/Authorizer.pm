package Lily::Plugin::Authorizer;
use strict;
use warnings;
use utf8;

sub import {
    my $self = shift;
    caller->add_trigger(BEFORE_ACTION => sub {
        my ($class,$c) = @_;

        if( $c->{req}->method eq 'POST' ) {


        }

        return 1;
    });
}

1;
