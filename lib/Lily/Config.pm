package Lily::Config;
use strict;
use warnings;
use utf8;

use YAML::XS;
use Data::Visitor::Encode;
use FindBin;
use Readonly;

my $config;

sub get {
    my $class = shift;

    return $config if $config;

    Readonly $config => $class->_load_file;
    return $config;
}

sub _load_file {
    my $class = shift;

    my $value = YAML::XS::LoadFile("$FindBin::Bin/config.yaml");

    return Data::Visitor::Encode->decode('utf8', $value);
}


1;
