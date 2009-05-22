package Lily::Model::DB;
use DBIx::Skinny;

__PACKAGE__->connect_info($config->{model}->{db}->{connect_info});

1;
