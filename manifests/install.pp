# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate::install {

  assert_private()

  if $agate::download_extension == '' {
    file { "/opt/agate-${agate::version}":
      ensure => directory,
      owner  => 'root',
      group  => 0, # 0 instead of root because OS X uses "wheel".
      mode   => '0755',
    }
    -> archive { "/opt/agate-${agate::version}/agate":
      ensure          => present,
      source          => $agate::download_url,
      checksum_verify => false,
      before          => File["/opt/agate-${agate::version}/agate"],
    }
  } else {
    archive { "/tmp/agate-${agate::version}.${agate::download_extension}":
      ensure          => present,
      extract         => true,
      extract_path    => '/opt',
      source          => $agate::download_url,
      checksum_verify => false,
      creates         => "/opt/agate-${agate::version}.amd64/agate",
      cleanup         => true,
      before          => File["/opt/agate-${agate::version}.amd64/agate"],
    }
  }
  file { "/opt/agate-${agate::version}.amd64/agate":
    owner => 'root',
    group => 'root',
    mode  => '0555',
  }
  -> file { "${agate::bin_dir}/agate":
    ensure => link,
    notify => Class['agate::service'],
    target => "/opt/agate-${agate::version}.amd64/agate",
  }

  if $agate::manage_user {
    ensure_resource(
      'user',[ $agate::user ],
      {
        ensure => 'present',
        system => true,
      }
    )

    if $agate::manage_group {
      Group[$agate::group] -> User[$agate::user]
    }
  }
  if $agate::manage_group {
    ensure_resource(
      'group', [ $agate::group ],
      {
        ensure => 'present',
        system => true,
      })
  }


}
