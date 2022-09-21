require 'spec_helper'

describe 'Pulpcore::LogLevel' do
  it { is_expected.to allow_value('CRITICAL') }
  it { is_expected.to allow_value('ERROR') }
  it { is_expected.to allow_value('WARNING') }
  it { is_expected.to allow_value('INFO') }
  it { is_expected.to allow_value('DEBUG') }
  it { is_expected.not_to allow_value('') }
end
