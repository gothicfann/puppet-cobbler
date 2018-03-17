class cobbler::config inherits cobbler::params {

  file { '/etc/cobbler/settings':
    ensure  => present,
    content => template("cobbler/settings.erb"),
    notify  => [ Service['httpd'], Service['cobblerd']],
  } ->

  file { '/etc/debmirror.conf':
    ensure  => present,
    content => file('cobbler/debmirror.conf'),
  } ->

  file { '/etc/cobbler/users.digest':
    ensure  => present,
    content => template('cobbler/users.digest.erb'),
    notify  => [ Service['httpd'], Service['cobblerd']],
  } ->

  file { "/var/lib/cobbler/snippets/${ks_name}":
    ensure => 'directory',
  } ->

  file { "/var/lib/cobbler/snippets/${ks_name}/ks_ssh_key":
    ensure  => present,
    content => template('cobbler/snippets/ks_ssh_key.erb'),
    notify  => Service['cobblerd'],
    mode    => '0644',
  } ->

  file { "/var/lib/cobbler/snippets/${ks_name}/ks_packages":
    ensure  => present,
    content => template('cobbler/snippets/ks_packages.erb'),
    notify  => Service['cobblerd'],
    mode    => '0644',
  } ->

  file { "/var/lib/cobbler/kickstarts/${ks_name}.ks":
    ensure  => present,
    content => template('cobbler/kickstarts/custom.ks.erb'),
    notify  => Service['cobblerd'],
    mode    => '0644',
  } ->

  exec { '/usr/bin/cobbler get-loaders':
    creates   => '/var/lib/cobbler/loaders/pxelinux.0',
    tries     => '2',
    try_sleep => '3',
  } ->

  exec { '/usr/bin/cobbler sync':
    refreshonly => true,
    tries       => '2',
    try_sleep   => '3',
    subscribe   => Service['cobblerd'] ,
  }
}
