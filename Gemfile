# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : '>= 5.5'

gem 'rake'
gem 'rspec', '~> 3.0'
gem 'rspec-puppet', '~> 2.3'
gem 'rspec-puppet-facts', '>= 1.7'
gem 'puppetlabs_spec_helper', '>= 2.1.1'
gem 'puppet-lint', '>= 2'
gem 'puppet-lint-classes_and_types_beginning_with_digits-check'
gem 'puppet-lint-empty_string-check'
gem 'puppet-lint-file_ensure-check'
gem 'puppet-lint-leading_zero-check'
gem 'puppet-lint-param-docs', '>= 1.3.0'
gem 'puppet-lint-spaceship_operator_without_tag-check'
gem 'puppet-lint-strict_indent-check'
gem 'puppet-lint-trailing_comma-check'
gem 'puppet-lint-undef_in_function-check'
gem 'puppet-lint-unquoted_string-check'
gem 'puppet-lint-variable_contains_upcase'
gem 'puppet-lint-version_comparison-check'
gem 'simplecov'
gem 'github_changelog_generator', '>= 1.15.0'
gem 'puppet-blacksmith', '>= 4.1.0', {"groups"=>["development"]}
gem 'beaker', '>= 4.2.0', {"groups"=>["system_tests"]}
gem 'beaker-docker', {"groups"=>["system_tests"]}
gem 'beaker-vagrant', {"groups"=>["system_tests"]}
gem 'beaker-hostgenerator', '>= 1.1.10', {"groups"=>["system_tests"]}
gem 'beaker-puppet', {"groups"=>["system_tests"]}
gem 'beaker-rspec', {"groups"=>["system_tests"]}
gem 'beaker-module_install_helper', {"groups"=>["system_tests"]}
gem 'beaker-puppet_install_helper', {"groups"=>["system_tests"]}
gem 'metadata-json-lint'
gem 'kafo_module_lint'
gem 'parallel_tests'

# vim:ft=ruby
