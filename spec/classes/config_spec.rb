# 2019-01-05 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'

default_cfg     = '/var/lib/agate/config/agate.yml'
default_user    = 'agate'
default_group   = 'agate'


describe tobj, :type => :class do
  describe "#{tobj}::config" do

    it { is_expected.to contain_class('systemd') }
    it { is_expected.to contain_systemd__unit_file('agate.service').with(
      'content' => File.read(fixtures('files', "agate.systemd"))
    )}
    context "with defaults" do
      it { is_expected.to contain_file(default_cfg).with({
        'ensure' => 'present',
        'owner'  => default_user,
        'group'  => default_group,
        'mode'   => '0440',
      }).that_notifies('Class[agate::service]')}
    end
    context 'when config_fn is /etc/agate/config.yml' do
      let (:params) {{ 'config_fn'.to_sym => '/etc/agate/config.yml' }}
      it { is_expected.to contain_file('/etc/agate/config.yml').with({
        'ensure' => 'present',
        'owner'  => default_user,
        'group'  => default_group,
        'mode'   => '0440',
      })}
    end

    context 'when user and group are george' do
      let (:params) {{
        'user'.to_sym  => 'george',
        'group'.to_sym => 'george',
      }}
      it { is_expected.to contain_file(default_cfg).with({
        'ensure' => 'present',
        'owner'  => 'george',
        'group'  => 'george',
        'mode'   => '0440',
      })}
    end
    [
      {
        title: 'should set listen addr',
        attr:   'listen_addr',
        value:  '4321',
        match:  %r{listen-addr: 4321},
      },
      {
        title: 'should set agate directory',
        attr:   'base_dir',
        value:  '/opt/agate',
        match:  %r{base-dir: /opt/agate},
      },
      {
        title: 'should set alert days',
        attr:   'alert_days',
        value:  24,
        match:  %r{max-days: 24},
      },
      {
        title: 'should set ticket url',
        attr:   'hpsm_url',
        value:  'https://hpsm:9876/api/v3',
        match:  %r{hpsm-url: https://hpsm:9876/api/v3},
      },
      {
        title: 'should set ticket user',
        attr:   'hpsm_user',
        value:  'frank',
        match:  %r{hpsm-user: frank},
      },
      {
        title: 'should set ticket password',
        attr:   'hpsm_pass',
        value:  'hpsmPass!',
        match:  %r{hpsm-pass: hpsmPass!},
      },
    ].each { |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let(:params) { { param[:attr].to_sym => param[:value] } }

        cfg_fn = '/var/lib/agate/config/agate.yml'

        it param[:title] do
          is_expected.to contain_file(cfg_fn).with_content(param[:match])
        end
      end
    }
    [
      {
        title: 'should set service user',
        attr:   'user',
        value:  'george',
        match:  %r{User=george},
      },
      {
        title: 'should set service group',
        attr:   'group',
        value:  'george',
        match:  %r{Group=george},
      },
    ].each { |param|
      context "when #{param[:attr]} is #{param[:value]}" do
        let(:params) { { param[:attr].to_sym => param[:value] } }

        it param[:title] do
          is_expected.
            to contain_systemd__unit_file('agate.service').
                 with_content(param[:match])
        end
      end
    }
  end
end
