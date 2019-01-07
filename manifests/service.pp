# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate::service {

  service { 'agate':
      ensure => 'restart',
      enable => true,
    }
}
