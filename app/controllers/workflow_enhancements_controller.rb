class WorkflowEnhancementsController < ApplicationController
  before_filter :find_project_by_project_id #, :authorize

  def show
    @roles = User.current.roles_for_project(@project)
    @tracker = Tracker.find(params[:tracker_id])
    issue_id = params[:issue_id]
    if issue_id
      @issue = Issue.find_by_id(issue_id)
    end
    render :layout => false
  end
end
