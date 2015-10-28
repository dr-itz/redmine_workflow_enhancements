require_dependency 'workflow_enhancements/hooks'
require_dependency 'workflow_enhancements/patches/action_view_rendering'
require_dependency 'workflow_enhancements/patches/tracker_patch'

Redmine::Plugin.register :redmine_workflow_enhancements do
  name 'Redmine Workflow Enhancements'
  author 'Daniel Ritz'
  description 'Enhancements for Workflow'
  version '0.5.0'
  url 'https://github.com/dr-itz/redmine_workflow_enhancements'
  author_url 'https://github.com/dr-itz/'

  requires_redmine '2.2.0'

  project_module :issue_tracking do
    permission :workflow_graph_view, :workflow_enhancements => :show
  end
end
