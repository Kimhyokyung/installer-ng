#
# Cookbook Name:: rackspace_timezone
# Test:: attributes_spec
#
# Author:: Christopher Coffey (<christopher.coffey@rackspace.com>)
#
# Copyright 2014, Rackspace, US, Inc.
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

require 'spec_helper'

describe 'check rackspace_timezone default attributes' do
  let(:chef_run) { ChefSpec::Runner.new.converge('rackspace_timezone::default') }
  let(:timezone) { chef_run.node['rackspace_timezone'] }

  it 'check default timezone' do
    expect(timezone['config']['tz']).to eq('UTC')
  end

  it 'check default tzdata directory' do
    expect(timezone['tzdata']).to eq('/usr/share/zoneinfo')
  end

  it 'check location of local timezone data' do
    expect(timezone['localtime_path']).to eq('/etc/localtime')
  end

  it 'check use of sym_link (default to false)' do
    expect(timezone['use_symlink']).to eq(false)
  end
end
