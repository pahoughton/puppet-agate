# 2019-01-05 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'

default_dir     = '/var/lib/agate'
default_user    = 'agate'
default_group   = 'agate'

describe tobj, :type => :class do
  it { is_expected.to contain_class(tobj) }
  it { is_expected.to contain_class('agate::config') }

  it { is_expected.to contain_file(default_dir).with(
    'ensure'  => 'directory',
    'owner'   => 'prometheus',
    'group'   => 'prometheus',
    'purge'   => true,
    'recurse' => true
  )}

  ["#{default_dir}/data",
   "#{default_dir}/scripts",
   "#{default_dir}/playbook/roles",
  ].each { |dir|
    it { is_expected.to contain_file(dir).with(
      'ensure' => 'directory',
      'owner'  => agate_user,
      'group'  => agate_group,
      'mode'   => '0775',
    )}
  }
  it { is_expected.to contain_package('agate') }
  it { is_expected.to contain_class('systemd') }
  it { is_expected.to contain_systemd__unit_file('agate.service').with(
    'content' => File.read(fixtures('files', "agate.systemd"))
  )}

  it { is_expected.to contain_service('agate').with(
    'ensure'     => 'running',
    'name'       => 'prometheus',
    'enable'     => true
  )}

  it { is_expected.to contain_exec('agate-reload').with(
    'command'     => 'systemctl reload agate',
    'path'        => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
    'refreshonly' => true
  )}

  opt_dir = '/opt/agate'
  context "when base_dir is #{opt_dir}" do
    let (:params) {{ 'base_dir'.to_sym => opt_dir }}

    ["#{default_dir}/data",
     "#{default_dir}/scripts",
     "#{default_dir}/playbook/roles",
    ].each { |dir|
      it { is_expected.to contain_file(dir).with(
        'ensure' => 'directory',
        'owner'  => agate_user,
        'group'  => agate_group,
        'mode'   => '0775',
      )}
    }
  end
end
