# 2019-01-05 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj '::agate::config'

default_cfg     = '/var/lib/agate/config/agate.yml'
default_user    = 'agate'
default_group   = 'agate'


describe tobj, :type => :class do
  context 'with defaults' do
    it { is_expected.to contain_file(default_cfg).with({
      'ensure' => 'present',
      'owner'  => default_user,
      'group'  => default_group,
      'mode'   => '0660',
    }).that_notifies('Class[agate::reload]')}
  end
  context 'when base_dir is /opt/agate' do
    let (:params) {{ 'base_dir'.to_sym => '/opt/agate' }}
    it { is_expected.to contain_file('/opt/agate/config/agate.yml').with({
      'ensure' => 'present',
      'owner'  => default_user,
      'group'  => default_group,
      'mode'   => '0660',
    })}
  end
  context 'when config_fn is /etc/agate/config.yml' do
    let (:params) {{ 'config_fn'.to_sym => '/etc/agate/config.yml' }}
    it { is_expected.to contain_file('/etc/agate/config.yml').with({
      'ensure' => 'present',
      'owner'  => default_user,
      'group'  => default_group,
      'mode'   => '0660',
    })}
  end
  context 'when user and group are george' do
    let (:params) {{ 'user'.to_sym => 'george' }}
    it { is_expected.to contain_file(default_cfg).with({
      'ensure' => 'present',
      'owner'  => 'george',
      'group'  => 'george',
      'mode'   => '0660',
    })}
  end
  [
    {
      title: 'should set listen addr',
      attr:   'listen_addr'
      value:  '4321'
      match:  %r{listen-addr: 4321},
    },
    {
      title: 'should set agate directory',
      attr:   'base_dir'
      value:  '/opt/agate'
      match:  %r{base-dir: /opt/agate},
    },
    {
      title: 'should set alert days',
      attr:   'alert_days'
      value:  '24'
      match:  %r{max-days: 24},
    },
    {
      title: 'should set ticket url',
      attr:   'hpsm_url'
      value:  'https://hpsm:9876/api/v3'
      match:  %r{ticket-url: https://hpsm:9876/api/v3},
    },
    {
      title: 'should set ticket user',
      attr:   'hpsm_user'
      value:  'frank'
      match:  %r{ticket-auth-user: frank},
    },
    {
      title: 'should set ticket password',
      attr:   'hpsm_pass'
      value:  'hpsmPass!'
      match:  %r{ticket-auth-pass: hpsmPass!},
    },
  ].each { |param|
    context "when #{param[:attr]} is #{param[:value]}" do
      let(:params) { { param[:attr].to_sym => param[:value] } }

      cfg_fn = '/var/lib/agate/config/agate.yml'
      if param[:attr] == 'base_dir'
        cfg_fn = "#{param[:value]}/config/agate.yml"
      end

      it param[:title] do
        is_expected.to contain_file(cfg_fn).with_content(param[:match])
      end
    end
  }
end
