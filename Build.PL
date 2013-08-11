
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.4004",
    "version" => "0.88"
  },
  "configure_requires" => {
    "Module::Build" => "0.4004",
    "version" => "0.88"
  },
  "dist_abstract" => "Inflates symbols in application config",
  "dist_author" => [
    "Peter Flanigan <pjfl\@cpan.org>"
  ],
  "dist_name" => "Catalyst-Plugin-InflateMore",
  "dist_version" => "0.6.1",
  "license" => "perl",
  "module_name" => "Catalyst::Plugin::InflateMore",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Catalyst" => "5.90010",
    "Data::Visitor" => "0.08",
    "Path::Class" => "0.16",
    "namespace::autoclean" => "0.05",
    "version" => "0.88"
  },
  "script_files" => [],
  "test_requires" => {}
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;