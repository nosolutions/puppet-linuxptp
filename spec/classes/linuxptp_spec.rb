require 'spec_helper'
describe 'linuxptp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({})
      end
      let(:params) do
        {}
      end

      context 'single instance defaults for all parameters' do
        let(:params) do
          super().merge({interfaces: ['eth0']})
        end
        it { should compile }
        it { should contain_class('linuxptp') }
        it { should contain_package('linuxptp').with_ensure('present') }
        it { should contain_file('/etc/sysconfig/ptp4l').with_content(/OPTIONS="-f \/etc\/ptp4l.conf -i eth0 "/) }
        it { should contain_file('/etc/sysconfig/phc2sys').with_content(/OPTIONS="-a -r -u 0"/) }
        it { should contain_linuxptp__ptp4l('default').with_filename('/etc/ptp4l.conf') }
        it { should contain_service('ptp4l').with_ensure('running') }
        it { should contain_service('phc2sys').with_ensure('running') }
        it { should contain_service('ptp4l').with_enable(true) }
        it { should contain_service('phc2sys').with_enable(true) }

        context 'with manage_logrotate_rule=false' do
          let(:params) do
            super().merge(manage_logrotate_rule: false)
          end
          it { should_not contain_logrotate__rule('linuxptp') }
        end
      end

      context 'multi instance defaults' do
        let(:params) do
          super().merge({single_instance: false})
        end
        it { should contain_file('/var/run/ptp4l').with_ensure('directory') }
        it { should contain_file('/etc/ptp4l').with_ensure('directory') }
        it { should contain_file('/var/log/linuxptp').with_ensure('directory') }
        it do
          should contain_logrotate__rule('linuxptp').with(
            'path'         => '/var/log/linuxptp/*.log',
            'compress'     => true,
            'copytruncate' => true,
            'missingok'    => true,
            'rotate_every' => 'day',
            'rotate'       => 7
          )
        end
        it { should contain_service('ptp4l').with_ensure('stopped') }
        it { should contain_service('phc2sys').with_ensure('stopped') }
        it { should contain_service('ptp4l').with_enable(false) }
        it { should contain_service('phc2sys').with_enable(false) }
      end
    end
  end
end
