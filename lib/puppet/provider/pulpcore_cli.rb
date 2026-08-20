# frozen_string_literal: true

require 'json'
require 'tempfile'

# Mixin for concrete providers that manage Pulp resources through the `pulp` CLI.
module Puppet::Provider::PulpcoreCli
  def self.included(provider_class)
    provider_class.commands pulp_binary: '/usr/bin/pulp'
    provider_class.extend(ClassMethods)
  end

  module ClassMethods
    def pulp(*args)
      pulp_binary('--format', 'json', *args)
    end

    def api_hash_by_href(href)
      parse_pulp_json(pulp('show', '--href', href))
    end

    # Parse a JSON response from the Pulp CLI, failing hard with a useful error
    # if the output is not valid JSON (e.g. a warning line or truncated list)
    # rather than letting a bare JSON::ParserError surface or silently treating
    # the resource as absent.
    def parse_pulp_json(response)
      JSON.parse(response)
    rescue JSON::ParserError => e
      raise Puppet::Error, "Unable to parse the Pulp CLI JSON response (#{e.message}). Response began with: #{response.to_s.strip[0, 200].inspect}"
    end
  end

  def pulp(*args)
    self.class.pulp(*args)
  end

  # Write sensitive or large option values to temporary files and pass them to
  # the Pulp CLI as @file arguments. The block must run the command while the
  # files are still open.
  def with_temp_file_arguments(file_arguments)
    tempfiles = []
    command_arguments = []

    begin
      file_arguments.each do |option, content|
        tempfile = Tempfile.new
        tempfile.chmod(0o600)
        tempfile.write(content)
        tempfile.flush

        tempfiles << tempfile
        command_arguments << option << "@#{tempfile.path}"
      end

      yield command_arguments
    ensure
      tempfiles.each(&:close!)
    end
  end
end
