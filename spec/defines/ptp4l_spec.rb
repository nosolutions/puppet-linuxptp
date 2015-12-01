require 'spec_helper'

describe 'linuxptp::ptp4l' do
  let(:name) { 'test' }
  let(:title) { 'test' }

  context 'with default parameters' do
    let (:params) {{
      :interfaces => [ 'eth0' ],
    }}
    it { should contain_file('/etc/ptp4l/test.conf').with_content(/^\[eth0\]/) }
    it { should contain_file('/etc/ptp4l/test.conf').with_content(/^clock_servo\s+pi$/) }
  end

  context 'with slave_only=1' do
    let (:params) {{
      :interfaces => [ 'eth0' ],
      :slave_only  => 1,
    }}
    it { should contain_file('/etc/ptp4l/test.conf').with_content(/^slaveOnly\s+1$/) }
  end

  context 'with hybrid_e2e=1' do
    let (:params) {{
      :interfaces => [ 'eth0' ],
      :hybrid_e2e  => 1,
    }}
    it { should contain_file('/etc/ptp4l/test.conf').with_content(/^hybrid_e2e\s+1$/) }
  end

  context 'with network_transport=L2' do
    let (:params) {{
      :interfaces        => [ 'eth0' ],
      :network_transport => 'L2',
    }}
    it { should contain_file('/etc/ptp4l/test.conf').with_content(/^network_transport\s+L2$/) }
  end

  context 'with invalid network_transport parameter' do
    let (:params) {{
      :interfaces        => [ 'eth0' ],
      :network_transport => 'broken',
    }}
    it { expect { should compile }.to raise_error(/Parameter 'network_transport' must be one of/) }
  end

  context 'with clock_servo=linear' do
    let (:params) {{
      :interfaces        => [ 'eth0' ],
      :clock_servo => 'linear'
    }}
    it { should contain_file('/etc/ptp4l/test.conf').with_content(/^clock_servo\s+linear$/) }
  end

  context 'with bad clock_servo' do
    let (:params) {{
      :interfaces        => [ 'eth0' ],
      :clock_servo => 'foo'
    }}
    it { expect { should compile }.to raise_error(/Parameter 'clock_servo' must be one of/) }
  end
end
