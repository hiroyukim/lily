package Lily::Engine;
use strict;
use warnings;
use utf8;

use HTTP::Engine;
use UNIVERSAL::require;

use Lily::Dispatcher;

sub run {
    my $self = shift;

    my $engine = HTTP::Engine->new({
        interface => {
            module => 'ServerSimple',
            args   => {
                host => 'localhost',
                port =>  10080,
            },
            request_handler => sub {
                my $req = shift;

                my $rule = Lily::Dispatcher->dispatch($req);
                $rule->{controller_class}->use;
                if ( $@ ) {
                    die $@;
                }

                $rule->{controller_class}->run($rule->{action}, $req);
            },
        },
    });
    $engine->run;
}

1;
