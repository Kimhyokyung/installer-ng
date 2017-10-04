rackspace_timezone
===========

The Rackspace-time cookbook contains recipes for installing the latest tzdata
(a.k.a. IANA or Olson) timezone database and setting the timezone on your
system.  It is a fork of the [timezone-ii cookbook by Larry
Gilbert.](https://github.com/L2G/timezone-ii)

Requirements
------------

This cookbook works with:

* CentOS and RHEL
* Debian
* Ubuntu


Attributes
----------

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tz']</tt></td>
    <td>String</td>
    <td>the timezone name as defined in tzdata</td>
    <td>UTC</td>
  </tr>
  <tr>
    <td><tt>['tzdata_dir']</tt></td>
    <td>String</td>
    <td>the path to the root of the tzdata files; the default value is for
    most known distributions of Linux</td>
    <td>/usr/share/zoneinfo</td>
  </tr>
  <tr>
    <td><tt>['localtime_path']</tt></td>
    <td>String</td>
    <td>the path to the file used by the kernel to read the local timezone's
    settings; the default works for Linux and other *ix variants</td>
    <td>/etc/localtime</td>
  </tr>
  <tr>
    <td><tt>['use_symlink']</tt></td>
    <td>Boolean</td>
    <td>whether to use a symlink into the tzdata tree rather than make a copy
    of the appropriate timezone data file (linux-generic recipe only)</td>
    <td>false</td>
  </tr>
</table>

Usage
-----

Set the "tz" attribute to your desired timezone and include the "rackspace-timezone"
recipe in your node's run list:

    {
      "name": "my_node",
      "tz": "Africa/Timbuktu",
      "run_list": [
        "recipe[rackspace_timezone]"
      ]
    }

### rackspace_timezone::default

The default recipe will first install or upgrade the IANA/Olson
timezone database package for your OS. Then it will configure the needed 
setting based on your OS.


Acknowledgements
----------------

Thanks to:

* James Harton, for launching the timezone cookbook
* Larry Gilbert for the timezone-ii cookbook
* "fraD00r4", for RHEL/CentOS support


License and Authors
-------------------

Copyright © 2010 James Harton <james@sociable.co.nz>             
Copyright © 2013 Lawrence Leonard Gilbert <larry@L2G.to>         
Copyright © 2013 Elan Ruusamäe <glen@delfi.ee>                   
Copyright © 2013 fraD00r4 <frad00r4@gmail.com>                   
Copyright © 2014 Rackspace, US Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
