# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate::service {

  service { 'agate':
      ensure => 'running',
      enable => true,
    }
}
