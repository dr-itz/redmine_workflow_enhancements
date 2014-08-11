Rails.configuration.to_prepare do
  ApplicationController.send(:helper, :workflow_enhancements)
end

Redmine::Plugin.register :redmine_workflow_enhancements do
  name 'Redmine Workflow Enhancements'
  author 'Daniel Ritz'
  description 'Enhancements for Workflow'
  version '0.1.1'
  url 'https://github.com/dr-itz/redmine_workflow_enhancements'
  author_url 'https://github.com/dr-itz/'

  requires_redmine '2.2.0'
end
