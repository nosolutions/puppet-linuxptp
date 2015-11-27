require 'spec_helper'
describe 'linuxptp::service' do
  context 'with default parameters' do
    it { should compile }
    it { should contain_class('linuxptp::service') }
    it { should contain_service('ptp4l').with_ensure('running') }
    it { should contain_service('phc2sys').with_ensure('running') }
    it { should contain_service('ptp4l').with_enable(true) }
    it { should contain_service('phc2sys').with_enable(true) }
  end
end
