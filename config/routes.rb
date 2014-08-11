match '/projects/:project_id/workflow_enhancements/:tracker_id/:issue_id',
  :to => 'workflow_enhancements#show', :via => :get,
  :as => 'workflow_show_graph'
