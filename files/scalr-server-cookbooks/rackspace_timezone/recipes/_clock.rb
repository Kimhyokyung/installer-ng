# encoding: UTF-8
#
# Cookbook Name:: rackspace_timezone
# Recipe:: _clock
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2014, Rackspace, US, Inc.
#
# Apache 2.0 License.

template '/etc/sysconfig/clock' do
  cookbook node['rackspace_timezone']['templates_cookbook']['clock']
  source 'clock.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'bash[tzdata-update]'
end

bash 'tzdata-update' do
  user 'root'
  code '/usr/sbin/tzdata-update'
  action :nothing
end
