require 'spec_helper'

describe 'linuxptp::ptp4l' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({})
      end

      let(:name) { 'test' }
      let(:title) { 'test' }
      let(:params) {{ interfaces: ['eth0']}}

      context 'with default parameters' do
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^\[eth0\]/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^clock_servo\s+pi$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^slaveOnly\s+0$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^hybrid_e2e\s+0$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^network_transport\s+UDPv4$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^udp_ttl\s+1$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logAnnounceInterval\s+1$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logSyncInterval\s+0$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logMinDelayReqInterval\s+0$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logMinPdelayReqInterval\s+0$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^delay_mechanism\s+E2E$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^time_stamping\s+hardware$/) }
      end

      context 'with completely different params' do
        let(:params) do
          super().merge({
            slave_only: 1,
            hybrid_e2e: 1,
            network_transport: 'L2',
            clock_servo: 'linreg',
            udp_ttl: 2,
            log_announce_interval: -2,
            log_sync_interval: -2,
            log_min_delay_req_interval: -2,
            log_min_pdelay_req_interval: -2,
          })
        end
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^slaveOnly\s+1$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^hybrid_e2e\s+1$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^network_transport\s+L2$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^clock_servo\s+linreg$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^udp_ttl\s+2$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logAnnounceInterval\s+-2$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logSyncInterval\s+-2$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logMinDelayReqInterval\s+-2$/) }
        it { should contain_file('/etc/ptp4l/test.conf').with_content(/^logMinPdelayReqInterval\s+-2$/) }
      end

      context 'with invalid network_transport parameter' do
        let(:params) do
          super().merge(network_transport: 'broken')
        end
        it { expect { should compile }.to raise_error(/Parameter 'network_transport' must be one of/) }
      end

      context 'with bad clock_servo' do
        let(:params) do
          super().merge(clock_servo: 'foo')
        end
        it { expect { should compile }.to raise_error(/Parameter 'clock_servo' must be one of/) }
      end

      context 'with invalid udp_ttl' do
        let(:params) do
          super().merge(udp_ttl: 'foo')
        end
        it { expect { should compile }.to raise_error(/Expected first argument to be a Numeric/) }
      end

      context 'with invalid log_announce_interval' do
        let(:params) do
          super().merge(log_announce_interval: 'foo')
        end
        it { expect { should compile }.to raise_error(/Expected first argument to be a Numeric/) }
      end

      context 'with invalid log_sync_interval' do
        let(:params) do
          super().merge(log_sync_interval: 'foo')
        end
        it { expect { should compile }.to raise_error(/Expected first argument to be a Numeric/) }
      end

      context 'with invalid log_min_delay_req_interval' do
        let(:params) do
          super().merge(log_min_delay_req_interval: 'foo')
        end
        it { expect { should compile }.to raise_error(/Expected first argument to be a Numeric/) }
      end

      context 'with invalid log_min_pdelay_req_interval' do
        let(:params) do
          super().merge(log_min_pdelay_req_interval: 'foo')
        end
        it { expect { should compile }.to raise_error(/Expected first argument to be a Numeric/) }
      end
    end
  end
end
