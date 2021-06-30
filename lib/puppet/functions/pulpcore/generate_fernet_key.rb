require 'securerandom'

Puppet::Functions.create_function(:'pulpcore::generate_fernet_key') do
  # @return 32 byte url-safe base64-encoded (with padding) Fernet symmetric encryption key
  dispatch :generate_fernet_key do
    return_type 'Pattern[/\A([a-zA-Z]|\d|-|_){43}=\z/]'
  end

  def generate_fernet_key
    SecureRandom.urlsafe_base64(32)+"="
  end
end
