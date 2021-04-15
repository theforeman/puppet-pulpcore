require 'spec_helper'

describe 'Pulpcore::ChecksumTypes' do 
  it { is_expected.to allow_value(['sha1']) }
  it { is_expected.to allow_value(['sha256']) }
  it { is_expected.not_to allow_values(['sha0', 'md3']) }
  it { is_expected.not_to allow_values([]) }
end
