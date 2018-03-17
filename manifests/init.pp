class cobbler (
  $cobbler_web_info = $cobbler::params::cobbler_web_info,
  $ks_name          = $cobbler::params::ks_name,
  $ks_root_passwd   = $cobbler::params::ks_root_passwd,
  $ks_packages      = $cobbler::params::ks_packages,
  $ks_ssh_key       = $cobbler::params::ks_ssh_key,
) {

  class { 'selinux': mode => 'permissive' }

  include cobbler::install
  include cobbler::config

}
