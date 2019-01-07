# 2019-01-05 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'agate'

default_dir     = '/var/lib/agate'
default_cfg     = '/var/lib/agate/config/agate.yml'
default_user    = 'agate'
default_group   = 'agate'

describe tobj, :type => :class do
  [tobj,
   'agate::install',
   'agate::config',
   'agate::service',
  ].each { |cls|
    it { is_expected.to contain_class(cls) }
  }
end
