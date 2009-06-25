package Lily::Plugin::FillInForm;
use strict;
use warnings;
use utf8;
use HTML::FillInForm;

sub import {
    my $self = shift;
    caller->add_trigger(AFTER_RENDER => sub {
        my ($class,$c) = @_;

        unless( $c->{req}->method eq 'POST' ) {

            my $param = $c->{req}->parameters;
            my $body  = $c->{res}->body;

            my $output = HTML::FillInForm->fill( \$body,$param );

            $c->{res}->body($output); 
        }

    });
}

1;
