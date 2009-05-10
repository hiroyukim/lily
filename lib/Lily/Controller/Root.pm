package Lily::Controller::Root;
use Lily::Controller;

on 'index' => sub {
    my ($self, $request) = @_;

    { hello => 'world' };
};

1;
