class cobbler (
  $cobbler_web_info = $cobbler::params::cobbler_web_info,
  $ks_name          = $cobbler::params::ks_name,
  $root_passwd      = $cobbler::params::root_passwd,
  $ks_pkgs          = $cobbler::params::ks_pkgs,
  $ssh_pub_key      = $cobbler::params::ssh_pub_key,
) {

  class { 'selinux': mode => 'permissive' }

  include cobbler::install
  include cobbler::config

}
