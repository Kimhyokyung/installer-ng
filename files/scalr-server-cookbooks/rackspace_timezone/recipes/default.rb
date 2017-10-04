# encoding: UTF-8
#
# Cookbook Name:: rackspace_timezone
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2014, Rackspace, US, Inc.
# Copyright 2014, Scalr, Inc.
#
# Apache 2.0 License.
# Make sure the tzdata database is installed.

package 'tzdata' do
  action :install
end

case node['platform']
when 'debian'
  if node['platform_version'].to_f >= 8
    include_recipe "rackspace_timezone::_timedatectl"
  else
    include_recipe "rackspace_timezone::_timezone"
  end
when 'ubuntu'
  include_recipe "rackspace_timezone::_timezone"
when 'redhat', 'centos'
  if node['platform_version'].to_f >= 7
    include_recipe "rackspace_timezone::_timedatectl"
  else
    include_recipe "rackspace_timezone::_clock"
  end
when 'fedora'
  if node['platform_version'].to_f >= 18
    include_recipe "rackspace_timezone::_timedatectl"
  else
    include_recipe "rackspace_timezone::_clock"
  end
end
