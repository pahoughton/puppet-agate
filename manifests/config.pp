# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate::config {

  assert_private()

  $daemon_flags = [
   "--config-file ${agate::config_fn}",
   "--debug ${agate::debug}",
  ]
  File {
    notify => Class['agate::service'],
  }

  include 'systemd'
  systemd::unit_file {'agate.service':
    content => template('agate/agate.systemd.erb'),
  }

  file { $agate::config_fn:
    ensure       => present,
    owner        => $agate::user,
    group        => $agate::group,
    mode         => '0440',
    notify       => Class['agate::service'],
    content      => template('agate/agate.yml.erb'),
  }

}
