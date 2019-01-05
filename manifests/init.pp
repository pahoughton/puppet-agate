# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate(
  Stdlib::Absolutepath $base_dir = '/var/lib/agate',
  Stdlib::Absolutepath $config_fn = '/var/lib/agate/config/agate.yml',
  String $user = 'agate',
  String $group = 'agate',
  String $listen_addr = ':1234',
  Numeric $alert_days = 15,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $hpsm_url = undef,
  String $hpsm_user = undef,
  String $hpsm_pass = undef,
  ) {

}
