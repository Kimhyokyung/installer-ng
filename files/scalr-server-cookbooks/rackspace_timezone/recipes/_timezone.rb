# encoding: UTF-8
#
# Cookbook Name:: rackspace_timezone
# Recipe:: _timezone
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2014, Rackspace, US, Inc.
#
# Apache 2.0 License.

template '/etc/timezone' do
  cookbook node['rackspace_timezone']['templates_cookbook']['timezone.conf']
  source 'timezone.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'bash[dpkg-reconfigure tzdata]'
end

bash 'dpkg-reconfigure tzdata' do
  user 'root'
  code '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata'
  action :nothing
end
