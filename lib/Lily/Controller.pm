package Lily::Controller;
use strict;
use warnings;
use utf8;

sub import {
    my $pkg = caller(0);
    strict->import;
    warnings->import;
    utf8->import;

    no strict 'refs';
    *{"$pkg\::on"} = sub {
        my ($action, $code) = @_;

        my $pkg = caller(0);
        *{"$pkg\::on_$action"} = $code;
    };

    *{"$pkg\::run"} = sub {
        my ($self, $action, $request) = @_;

        *{"$pkg\::on_$action"}->($self, $request);
    }

}

1;
