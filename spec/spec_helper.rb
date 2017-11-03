require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'rspec-puppet-utils'

include RspecPuppetFacts

RSpec.configure do |c|
  #c.fail_fast = true

  # Enable disabling of tests
  c.filter_run_excluding :broken => true

  c.default_facts = {
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '6',
    :concat_basedir         => '/dne',
    :pop                    => 'foo',
  }
  #Set Fact for Puppet Version
  add_custom_fact :puppetversion, Puppet.version
  if Puppet.version =~ /^4/
    add_custom_fact :is_pe,                  false
    add_custom_fact :puppet_client_datadir,  '/opt/puppetlabs/puppet/cache/client_data'
    add_custom_fact :puppet_confdir,         '/etc/puppetlabs/puppet'
    add_custom_fact :puppet_config,          '/etc/puppetlabs/puppet/puppet.conf'
    add_custom_fact :puppet_environmentpath, '/etc/puppetlabs/code/environments'
    add_custom_fact :puppet_master_server,   'puppet'
    add_custom_fact :puppet_ssldir,          '/etc/puppetlabs/puppet/ssl'
    add_custom_fact :puppet_stringify_facts, false
    add_custom_fact :puppet_vardir,          '/opt/puppetlabs/puppet/cache'
  end
end
