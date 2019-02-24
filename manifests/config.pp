# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate::config {

  assert_private()

  ensure_resource(
    'file',
    [ $agate::data_dir,
      $agate::config_dir,],
    {
      ensure => 'directory',
      owner  => $agate::user,
      group  => $agate::group,
      mode   => '0775'
    }
  )

  $daemon_flags = [
    "--addr ${agate::listen}",
    "--config ${agate::config_file}",
    "--data ${agate::data_dir}",
  ]
  File {
    notify => Class['agate::service'],
  }

  include 'systemd'
  systemd::unit_file {'agate.service':
    content => template('agate/agate.systemd.erb'),
  }

  file { $agate::config_file:
    ensure  => present,
    owner   => $agate::user,
    group   => $agate::group,
    mode    => $agate::config_mode,
    notify  => Class['agate::service'],
    content => template('agate/agate.yml.erb'),
  }

}
