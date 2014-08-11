class WorkflowEnhancementsController < ApplicationController
  before_filter :find_project_by_project_id #, :authorize

  def show
    @roles = User.current.roles_for_project(@project)
    @tracker = Tracker.find(params[:tracker_id])
    render :layout => false
  end
end
