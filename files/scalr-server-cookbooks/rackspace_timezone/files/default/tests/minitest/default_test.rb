# encoding: UTF-8
require 'minitest/spec'

describe_recipe 'rackspace_timezone::default' do
  include TimezoneIiSpec < MiniTest::Chef::Spec
  it 'updates the timezone' do
    IO.read('/etc/localtime').must_equal IO.read("/usr/share/zoneinfo/#{node['rackspacezone_time']['tz']}")
  end
end
