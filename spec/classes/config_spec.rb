require 'spec_helper'
describe 'linuxptp::config' do
  context 'with default parameters' do
    it { should compile }
    it { should contain_class('linuxptp::config') }
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
  end

  context 'with manage_logrotate_rule=false' do
    let (:params) {{
      :manage_logrotate_rule => false
    }}
    it { should_not contain_logrotate__rule('linuxptp') }
  end
end
