require 'spec_helper'
describe 'linuxptp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({})
      end
      let(:params) do
        { }
      end

      context 'single instance defaults for all parameters' do
        let(:params) do
          super().merge({})
        end
        it { should compile }
        it { should contain_class('linuxptp') }
        it { should contain_class('linuxptp::params') }
        it { should contain_class('linuxptp::install') }
        it { should contain_class('linuxptp::config') }
        it { should contain_class('linuxptp::service') }

        it { should contain_package('linuxptp').with_ensure('present') }

        it { should contain_file('/var/run/ptp4l').with_ensure('directory') }
        it { should contain_file('/etc/ptp4l').with_ensure('directory') }
        it { should contain_file('/var/log/linuxptp').with_ensure('directory') }
        it { should contain_logrotate__rule('linuxptp').with(
          'path'         => '/var/log/linuxptp/*.log',
          'compress'     => true,
          'copytruncate' => true,
          'missingok'    => true,
          'rotate_every' => 'day',
          'rotate'       => 7
        )}
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

      end
    end
  end
end
