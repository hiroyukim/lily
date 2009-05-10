package Lily::Controller::Root;
use Lily::Controller;

on 'index' => sub {
    my ($self, $request) = @_;

    my $res = HTTP::Engine::Response->new;
    $res->status(200);
    $res->body("run index");

    $res;
};

1;
