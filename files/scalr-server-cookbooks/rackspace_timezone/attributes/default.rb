# encoding: utf-8
# Author:: Christopher Coffey (<christopher.coffey@rackspace.com>)
# Copyright:: Copyright (c) 2014, Rackspace, US, Inc.
#
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['rackspace_timezone']['config']['tz'] = 'UTC'

# Path to tzdata directory
default['rackspace_timezone']['tzdata'] = '/usr/share/zoneinfo'

# Path to file used by kernel for local timezone's data
default['rackspace_timezone']['localtime_path'] = '/etc/localtime'

# Whether to use a symlink to tzdata (instead of copying).
default['rackspace_timezone']['use_symlink'] = false

# Location of templates
default['rackspace_timezone']['templates_cookbook']['timezone.conf'] = 'rackspace_timezone'
default['rackspace_timezone']['templates_cookbook']['clock'] = 'rackspace_timezone'
