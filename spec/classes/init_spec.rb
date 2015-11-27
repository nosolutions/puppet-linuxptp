require 'spec_helper'
describe 'linuxptp' do

  context 'with defaults for all parameters' do
    it { should compile }
    it { should contain_class('linuxptp') }
    it { should contain_class('linuxptp::params') }
    it { should contain_class('linuxptp::install') }
    it { should contain_class('linuxptp::config') }
    it { should contain_class('linuxptp::service') }
  end
end
