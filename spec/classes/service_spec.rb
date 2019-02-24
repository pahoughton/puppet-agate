# 2019-01-07 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'

default_dir     = '/var/lib/agate'
default_cfg     = '/var/lib/agate/config/agate.yml'
default_user    = 'agate'
default_group   = 'agate'

describe tobj, :type => :class do
  describe "#{tobj}::service" do
    it { is_expected.to contain_service('agate').with(
      'ensure'     => 'running',
      'enable'     => true
    )}
  end
end
