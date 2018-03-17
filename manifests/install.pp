class cobbler::install inherits cobbler::params {

  package { 'epel-release':
    ensure => installed,
  }

  package { $deps:
    ensure => installed,
  }

  package { 'cobbler':
    ensure => installed,
  }

  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }

  service { 'rsyncd':
    ensure => running,
    enable => true,
  }

  service { 'tftp':
    ensure => running,
  }

  service { 'cobblerd':
    ensure  => running,
    enable  => true,
    require => Service['httpd']
  }

}
