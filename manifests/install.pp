# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate::install {

  assert_private()

  ensure_packages(['agate'], { ensure => 'present' })

  if $agate::manage_user {
    ensure_resource('user', [ $agate::user ], {
      ensure => 'present',
      system => true,
    })

    if $agate::manage_group {
      Group[$agate::group] -> User[$agate::user]
    }
  }
  if $agate::manage_group {
    ensure_resource('group', [ $agate::group ],{
      ensure => 'present',
      system => true,
    })
  }

  ensure_resource('file',
  ["${agate::base_dir}/data",
   "${agate::base_dir}/scripts",
   "${agate::base_dir}/playbook",
   "${agate::base_dir}/playbook/roles",],{
     ensure => 'directory',
     owner  => $agate::user,
     group  => $agate::group,
     mode   => '0775'
     })

}
