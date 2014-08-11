module WorkflowEnhancements
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
      :partial => 'workflow_enhancements/issue_popup'
  end
end
