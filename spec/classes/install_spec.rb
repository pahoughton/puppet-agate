# 2019-01-07 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'
default_data    = '/opt/agate/data'
default_cfg     = '/etc/agate/agate.yml'
default_user    = 'agate'
default_group   = 'agate'

describe tobj, :type => :class do
  describe "#{tobj}::install" do

    context "with defaults" do
      ["#{default_data}",
      ].each { |dir|
        it { is_expected.to contain_file(dir).with(
          'ensure' => 'directory',
          'owner'  => default_user,
          'group'  => default_group,
          'mode'   => '0775',
        )}
      }
    end

    data_dir = '/var/lib/agate'
    context "when data_dir is #{data_dir}" do
      let (:params) {{ 'data_dir'.to_sym => data_dir }}

      ["#{data_dir}",
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
