# 2019-01-05 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'

default_cfg     = '/etc/agate/agate.yml'
default_user    = 'agate'
default_group   = 'agate'


describe tobj, :type => :class do
  describe "#{tobj}::config" do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { is_expected.to contain_class('systemd') }
        it { is_expected.to contain_systemd__unit_file('agate.service').
                              with('content' =>
                                   File.read(fixtures('files',
                                                      "agate.systemd"))
          )}
        context "with defaults" do
          it { is_expected.to \
            contain_file(default_cfg).with(
              { 'ensure' => 'present',
                'owner'  => default_user,
                'group'  => default_group,
                'mode'   => '0660',
              }).that_notifies('Class[agate::service]')}
        end
        context 'when config_file is /etc/agate/config.yml' do

          let (:params) {
            { 'config_file'.to_sym => '/etc/agate/config.yml' }
          }

          it { is_expected.to contain_file('/etc/agate/config.yml').with(
                                { 'ensure' => 'present',
                                  'owner'  => default_user,
                                  'group'  => default_group,
                                  'mode'   => '0660',
                                })}
        end

        context 'when user and group are george' do
          let (:params) {
            {
              'user'.to_sym  => 'george',
              'group'.to_sym => 'george',
            }}
          it { is_expected.to contain_file(default_cfg).with(
                                {
                                  'ensure' => 'present',
                                  'owner'  => 'george',
                                  'group'  => 'george',
                                  'mode'   => '0660',
                                })}
        end
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
  end
end
