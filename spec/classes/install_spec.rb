# 2019-01-07 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'

default_dir     = '/var/lib/agate'
default_cfg     = '/var/lib/agate/config/agate.yml'
default_user    = 'agate'
default_group   = 'agate'

describe tobj, :type => :class do
  describe "#{tobj}::install" do

    it { is_expected.to contain_package('agate') }

    context "with defaults" do
      ["#{default_dir}/data",
       "#{default_dir}/scripts",
       "#{default_dir}/playbook/roles",
      ].each { |dir|
        it { is_expected.to contain_file(dir).with(
          'ensure' => 'directory',
          'owner'  => default_user,
          'group'  => default_group,
          'mode'   => '0775',
        )}
      }
    end

    opt_dir = '/opt/agate'
    context "when base_dir is #{opt_dir}" do
      let (:params) {{ 'base_dir'.to_sym => opt_dir }}

      ["#{opt_dir}/data",
       "#{opt_dir}/scripts",
       "#{opt_dir}/playbook/roles",
      ].each { |dir|
        it { is_expected.to contain_file(dir).with(
          'ensure' => 'directory',
          'owner'  => default_user,
          'group'  => default_group,
          'mode'   => '0775',
        )}
      }
    end
  end
end
