# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate (
  String $version,
  Stdlib::Absolutepath $config_dir,
  Stdlib::Absolutepath $config_file,
  String $config_mode,
  Stdlib::Absolutepath $data_dir,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $download_url,
  String $download_extension,
  Hash $config,
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Absolutepath $bin_dir,
  String $extra_options,
  ) {

  contain agate::install
  contain agate::config
  contain agate::service

  Class['agate::install']
  -> Class['agate::config']
  -> Class['agate::service']

}
