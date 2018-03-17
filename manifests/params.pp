class cobbler::params {

  $deps = ['cobbler-web',
           'tftp-server',
           'tftp',
           'httpd',
           'rsync',
           'syslinux',
           'debmirror',
           'fence-agents',
           'pykickstart',
           'ipxe-bootimgs',
           'wget',]

  $cobbler_web_info = 'cobbler:Cobbler:a2d6bae81669d707b72c0bd9806e01f3'

  $ks_name = 'custom'
  $ks_root_passwd = '$6$random_salt$dzyAsrsC9bn7UOidCruJkOxSffzsuwzOzTwkPUTuYcwppDjUQwt9ZSWYzUhA/FN7QjaxhdN8s3rVjbY8iMBkg1'
  $ks_ssh_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK9/TRBjbtpdBuXeOPaVbnQZF0/TbZG5VIPCs3ICukfnlkqqjYL27qY5J1ujeHNHrUnZBpEcuqRh5vIQU0T0qugus2LcubPuPvys/F0rXhx8oymFgRYXQAJb4Vy99JxCzwVQZ7t2MPnmNHnHyTDV0s9uFqNwRFLypPUJDqcEMyy4Qq3xXrIToUUggZPp4gi40V7N+kj3Q7K7xrQM2pH/M3krJr8qNpNUrkjP4XjA6Dc46Xx0kQs9f9OXQgKK05C5jr3gAgz2tvQpR14gg/bDmt9fVnMH2571RPAwUdXmtaOWSyk2zIMoYGXaHeRPiZQic5hYcZ2Z9+Qj/lGp8NJ0n9 cobbler@example.com'
  $ks_packages = ['vim',
                  'git',
                  'wget',
                  'mlocate',]

}
