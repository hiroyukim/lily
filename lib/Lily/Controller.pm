package Lily::Controller;
use strict;
use warnings;
use utf8;
use base qw/Class::Data::Inheritable/;

use String::CamelCase ();
use Text::MicroTemplate::File;
use HTTP::Engine::Response;
use FindBin;
use Class::Trigger qw(BEFORE_ACTION AFTER_ACTION BEFORE_RENDER AFTER_RENDER);
use UNIVERSAL::require;

__PACKAGE__->mk_classdata($_) for qw/load_plugins/;
__PACKAGE__->load_plugins([qw/
    Validator
    FillInForm
/]);

sub import {
    my $pkg = caller(0);
    strict->import;
    warnings->import;
    utf8->import;

    # setup plugins
    #FIXME: 動的化
    #my %register_plugins = context->config->{register_plugins};
    for my $plugin ( map { s/\A\+// ? $_ : "Lily::Plugin::$_" } @{__PACKAGE__->load_plugins} ) {
    #    next unless $register_plugins{$plugin}; 
        $plugin->use or die $@;
    }

    no strict 'refs';
    *{"$pkg\::on"} = sub {
        my ($action, $code) = @_;

        my $pkg = caller(0);
        *{"$pkg\::on_$action"} = $code;
    };

    #FIXME: コンテキストを考慮した仕組みにしたい
    my $c = {}; # Lily::Context ?
    *{"$pkg\::run"} = sub {
        my ($self, $action, $request) = @_;

        $c->{req}    = $request; 
        $c->{action} = $action;

        __PACKAGE__->call_trigger('BEFORE_ACTION',$c); 
        my $stash = *{"$pkg\::on_$action"}->($self, $request);
        $c->{stash} = $stash;
        __PACKAGE__->call_trigger('AFTER_ACTION',$c);

        if ( !$stash or ref($stash) ne 'HTTP::Engine::Response' ) {
            my $response = HTTP::Engine::Response->new;
            $response->status(200);

            $c->{res} = $response;

            my $tmpl_path = $pkg;
            $tmpl_path =~ s!Lily::Controller::(Root)?!!g;
            $tmpl_path = join('/', map { String::CamelCase::decamelize($_) } split /::/, $tmpl_path);

            $c->{tmpl_path} = $tmpl_path;

            my $mtf= Text::MicroTemplate::File->new(
                include_path => [ "$FindBin::Bin/assets/tmpl" ],
                use_cache    => 1,
            );

            __PACKAGE__->call_trigger('BEFORE_RENDER',$c);
            $response->body($mtf->render_file("$tmpl_path/$action.html", $request, $stash)->as_string);
            __PACKAGE__->call_trigger('AFTER_RENDER',$c);
            return $response;
        }
        else {
            return $stash;
        }
    }
}

1;
