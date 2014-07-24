require 'simplecov'

if Dir.pwd.match(/plugins\/redmine_workflow_enhancements/)
  covdir = 'coverage'
else
  covdir = 'plugins/redmine_workflow_enhancements/coverage'
end

SimpleCov.coverage_dir(covdir)
SimpleCov.start 'rails' do
  add_filter do |source_file|
    # only show files belonging to the plugin, except init.rb which is not fully testable
    source_file.filename.match(/redmine_workflow_enhancements/) == nil ||
      source_file.filename.match(/redmine_workflow_enhancements\/init.rb/) != nil
  end
end

# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Ensure that we are using the plugin's fixtures
# This is necessary as the Redmine fixtures are too complex and don't cover all needs
ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
ActionDispatch::IntegrationTest.fixture_path = File.expand_path("../fixtures", __FILE__)
