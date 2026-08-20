# frozen_string_literal: true

module PuppetX
  module Pulpcore
    # Helpers shared across the Pulpcore Puppet types.
    module TypeHelpers
      # Munge truthy/falsey user input to the :true / :false symbols the
      # providers use internally.
      def munge_boolean_to_symbol(value)
        value = value.downcase if value.respond_to? :downcase

        case value
        when true, :true, 'true', :yes, 'yes'
          :true
        when false, :false, 'false', :no, 'no'
          :false
        else
          raise ArgumentError, 'expected a boolean value'
        end
      end
    end
  end
end
