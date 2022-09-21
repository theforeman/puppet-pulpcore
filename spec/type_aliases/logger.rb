require 'spec_helper'

describe 'Pulpcore::Logger' do
  it { is_expected.to allow_value({level: 'CRITICAL'}) }
  it { is_expected.not_to allow_value({}) }
  it { is_expected.not_to allow_value(nil) }
end
