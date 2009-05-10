package Lily::Controller;
use strict;
use warnings;
use utf8;

use String::CamelCase ();
use Text::MicroTemplate::File;
use HTTP::Engine::Response;
use FindBin;

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

        my $res = *{"$pkg\::on_$action"}->($self, $request);
        if ( !$res or ref($res) ne 'HTTP::Engine::Response' ) {
            my $response = HTTP::Engine::Response->new;
            $response->status(200);

            my $tmpl_path = $pkg;
            $tmpl_path =~ s!Lily::Controller::(Root)?!!g;
            $tmpl_path = join('/', map { String::CamelCase::decamelize($_) } split /::/, $tmpl_path);

            my $mtf= Text::MicroTemplate::File->new(
                include_path => [ "$FindBin::Bin/assets/tmpl" ],
                use_cache    => 1,
            );

            $response->body($mtf->render_file("$tmpl_path/$action.html", $request, $res)->as_string);
            return $response;
        }
        else {
            return $res;
        }
    }

}

1;
