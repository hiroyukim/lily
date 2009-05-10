package Lily::Dispatcher;
use strict;
use warnings;
use HTTPx::Dispatcher;
use String::CamelCase qw//;

connect ''                     => { controller => 'root', action => 'index' };
connect ':controller/'         => { action => 'index' };
connect ':controller/:action';
connect ':action'              => { controller => 'root', };

sub dispatch {
    my ( $class, $req ) = @_;

    my $rule = $class->match($req);
    $rule->{controller_class} = "Lily::Controller::" . String::CamelCase::camelize($rule->{controller});
    $rule->{controller_class} =~ s!/!::!g;

    $rule;
}

1;

