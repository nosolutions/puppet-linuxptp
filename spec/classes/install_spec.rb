require 'spec_helper'
describe 'linuxptp::install' do
  context 'with default parameters' do
    it { should compile }
    it { should contain_class('linuxptp::install') }
    it { should contain_package('linuxptp').with_ensure('present') }
  end
end
