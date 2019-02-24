# 2019-01-05 (cc) <paul4hough@gmail.com>
#
class agate (
  String $version,
  String $listen,
  Stdlib::Absolutepath $config_dir,
  Stdlib::Absolutepath $config_file,
  String $config_mode,
  Stdlib::Absolutepath $data_dir,
  Optional[String] $download_url,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $download_url_base,
  String $download_extension,
  Hash $config,
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Absolutepath $bin_dir,
  String $extra_options,
) {

  $real_download_url = pick(
    $download_url,
    "${download_url_base}/v${version}/agate-${version}.amd64.${download_extension}")

  notify { "agate version: ${version}": }
  contain agate::install
  contain agate::config
  contain agate::service

  Class['agate::install']
  -> Class['agate::config']
  -> Class['agate::service']

}
