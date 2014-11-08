require File.expand_path('../../test_helper', __FILE__)

class WorkflowEnhancementsControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :issue_categories,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :enumerations,
           :workflows

  def setup
    User.current = nil
    @request.session[:user_id] = 2 # manager
  end

  def test_show_as_manager_newissue
    get :show, :project_id => 1, :tracker_id => 1, :issue_id => 1
    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:project)
    assert_not_nil assigns(:roles)
    assert_not_nil assigns(:tracker)

    # test if workflow visualization is there
    assert_select 'svg#workflow-vis', true
    assert_select 'graphContextual', false
  end
end
