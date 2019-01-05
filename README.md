## puppet-agate

[![Test Build Status](https://travis-ci.org/pahoughton/puppet-agate.png)](https://travis-ci.org/pahoughton/puppet-agate)

Install and configure [agate](https://github.com/pahoughton/agate)
prometheus [alertmanager](https://prometheus.io/docs/alerting/alertmanager/)
alert gateway.

## usage

```puppet
class { '::agate':
  base_dir		=> '/var/lib/agate',
  config_fn		=> '/var/lib/agate/config/agate.yml',
  user			=> 'agate',
  group			=> 'agate',
  listen_addr   => ':1234',
  alert_days    => '15',
  hpsm_url		=> 'http://host:port/ticket',
  hpsm_user		=> 'george',
  hpsm_pass		=> 'password',
}
```

## limitations

* centos / rhel 7

## contribute

https://github.com/pahoughton/puppet-agate

## licenses

2019-01-05 (cc) <paul4hough@gmail.com>

GNU General Public License v3.0

See [COPYING](../master/COPYING) for full text.
