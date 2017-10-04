# encoding: UTF-8
#
# Cookbook Name:: rackspace_timezone
# Recipe:: _timedatectl
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2014, Rackspace, US, Inc.
#
# Apache 2.0 License.

bash 'timedatectl set-timezone' do
  user 'root'
  code "/usr/bin/timedatectl --no-ask-password set-timezone #{node['rackspace_timezone']['config']['tz']}"
end
