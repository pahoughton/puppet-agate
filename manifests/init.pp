# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate (
  Stdlib::Absolutepath $base_dir,
  Stdlib::Absolutepath $config_fn,
  String $user,
  Boolean $manage_user,
  String $group,
  Boolean $manage_group,
  String $listen_addr,
  Numeric $alert_days,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $hpsm_url,
  String $hpsm_user,
  String $hpsm_pass,
  String $extra_options,
  Boolean $debug,
  ) {

  contain agate::install
  contain agate::config
  contain agate::service

  Class['agate::install']
  -> Class['agate::config']
  -> Class['agate::service']

}
