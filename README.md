Squall
=========================================================

A Ruby library for working with the [OnApp REST API][].

Squall has been tested on MRI versions 1.9.2, 1.9.3, 2.0.0 and 1.9-compatible
JRuby.

This is a fork of the [Squall Library](https://github.com/site5/squall/) originally 
written by Site5 and updated by myself (Suhail Patel) to add some modules and update 
some bits to use the OnApp 3.1 API.

This is an experimental fork and should only be used after testing with a proper
3.1 instance. The current tests still utilise the Site5 v2.3 OnApp API fork but
most bits should work with little tweaking on OnApp 3.1

[OnApp REST API]: http://onapp.com/cloud/technology/api/

Install
-------

To install Squall using [Bundler](http://bundler.io):

```
echo "gem 'squall', git: 'http://github.com/suhailpatel/squall.git'" >> Gemfile
bundle install
```

Configuration
-------------

You have two main options for configuring Squall.

Directly in a config block:

```ruby
require 'squall'

Squall.config do |c|
  c.base_uri 'https://onappurl.com' # Root level URI for OnApp instance
  c.username 'username'             # OnApp username
  c.password 'topsecret'            # OnApp password
  c.debug     true                  # Toggle HTTP/Faraday debugging (prints to $stderr)
end
```

Squall can load configuration from a yaml file:

```yaml
# .squall.yml
base_uri: 'https://onappurl.com'
username: 'username'
password: 'topsecret'
debug: false
```

To load it (by default it assumes ~/.squall.yml):

```ruby
Squall.config_file("/path/to/.squall.yml")
```

It is also possible to change individual configuration settings on the fly.

```ruby
Squall.configuration.debug(true)
```

Note: you will need to re-instantiate all modules after changing Squall's configuration.

Usage
-----

Show the info for a VM:

```ruby
vm = Squall::VirtualMachine.new
vm.show 1
```

Create a new VM:

```ruby
vm = Squall::VirtualMachine.new

params = {
  label:             'testmachine',
  hypervisor_id:     5,
  hostname:          'testmachine',
  memory:            512,
  cpus:              1,
  cpu_shares:        10,
  primary_disk_size: 10,
  template_id:       1
}

vm.create params
```

Supported Methods
-----------------

This gem partially implements the OnApp API v3.0+

The following OnApp modules have been added:

* Data store zones
* Firewall rules
* Hypervisors
* Hypervisor zones
* IP addresses
* IP address joins
* Networks
* Network zones
* Users
* User groups
* Roles
* Statistics
* Templates
* Transactions
* Virtual machines
* Whitelists
* Disks
* DNS Zones
* Backups

The following still need to be added:

* Billing plans
* Currencies
* Network interfaces
* Template groups
* Software licenses
* Resolvers
* VM autoscaling
* Load Balancers
* CDN edge servers
* CDN resources
* CDN edge groups
* Autobackup Presets
* Schedules
* SSH keys
* Alerts
* Logs
* System configuration

Tests
-----

Squall uses rspec for tests. To run:

```
bundle exec rake # Runs all tests
bundle exec rspec spec/squall/[module]_spec.rb # Runs tests for a specific module
```

Squall uses [VCR](https://github.com/myronmarston/vcr) to cache server
responses to test against. To test via live http connections, pass RERECORD=1
into test command. NOTE: since OnApp does not currently support a test
environment this is not recommended unless you know what you're doing, as it
will destroy live data!

Known issues:

1. VirtualMachine#change_user currently breaks the parser on an invalid
   user_id  because OnApp returns html instead of JSON
2. VirtualMachine#create is currently broken in certain cases.
3. FirewallRule#edit and #create break the parser by returning invalid JSON

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010-2014 Site5.com. See LICENSE for details.
Updated by Suhail Patel (suhail@onapp.com) for OnApp 3.1
