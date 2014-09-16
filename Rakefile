require 'bundler/setup'
require 'rspec/core/rake_task'
require 'nsidc_deployment_helper'
require 'nsidc_deployment_helper/jetty'
require 'nsidc_deployment_helper/setup_auth_agents'
require 'nsidc_deployment_helper/deployment_log'
require 'nsidc_deployment_helper/tar_artifact'
require File.join('.', 'config', 'deployment_config.rb')
require File.join('.', 'lib', 'version.rb')

Dir.glob('./tasks/*.rake').each { |r| import r }

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path('../', __FILE__))

desc 'Run local webserver instance'
task :run do
  # require gems here to avoid conflicts between rake and sinatra-contrib
  Bundler.require(:default)

  # The following line should enable an ssl connection, but it currently doesn't work https://github.com/puma/puma/issues/522
  # sh 'puma -b ssl://0.0.0.0:3000\?key=/home/vagrant/tmp/cert/server.key\&cert=/home/vagrant/tmp/cert/server.csr -t 1:1 -w 5 -e development -C "-"'

  sh 'puma -b tcp://0.0.0.0:3000 -t 1:1 -w 5 -e development -C "-"'
end

task default: 'spec:unit'

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.rspec_opts = %w(-f progress -f JUnit -o results.xml)
  end

  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.rspec_opts = %w(-f progress -f RSpecTurnipFormatter -o results.html -f JUnit -o results.xml)
    t.pattern = './spec/acceptance/**/*{.feature}'
  end
end

task 'rubocop' do
  sh 'curl -o .rubocop.yml https://bitbucket.org/nsidc/lint-test-tools/raw/master/Ruby/.rubocop.yml'
  sh 'bundle exec rubocop --config .rubocop_project.yml'
end
