# encoding: UTF-8
name             'rackspace_timezone'
maintainer       'Rackspace, US, Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Configure the system timezone on Linux systems'
version          '1.0.1'

recipe 'rackspace_timezone', 'Set time zone details on server'

%w{debian ubuntu centos redhat fedora}.each do |os|
    supports os
end

replaces         'timezone'
replaces         'timezone-ii'
