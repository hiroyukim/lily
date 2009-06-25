package Lily::Plugin::Validator;
use strict;
use warnings;
use utf8;

sub import {
    my $self = shift;
    caller->add_trigger(BEFORE_ACTION => sub {
        my ($class,$c) = @_;

        #return unless $c->{req}->method eq 'POST';

        
        warn $class . "\n";

    });
}

1;
