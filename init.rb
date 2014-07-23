Redmine::Plugin.register :redmine_workflow_enhancements do
  name 'Redmine Workflow Enhancements'
  author 'Daniel Ritz'
  description 'Enhancements for Workflow'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  requires_redmine '2.1.0'
end

Rails.configuration.to_prepare do
  ApplicationController.send(:helper, WorkflowEnhancements::ViewHelper)
end
