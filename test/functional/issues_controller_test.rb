require File.expand_path('../../test_helper', __FILE__)

class IssuesControllerTest < ActionController::TestCase
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

  def test_show_by_manager_with_permission
    Role.find(1).add_permission! :workflow_graph_view
    get :show, :id => 1
    assert_response :success
    assert_template 'show'

    assert_equal Issue.find(1), assigns(:issue)

    # test if standard Redmine stuff is there (i.e. render_super() works)
    assert_select 'a', :text => /Quote/
    assert_select 'form#issue-form', true
    assert_select '#issue_tracker_id', true

    # test if workflow visualization is there
    assert_select '#workflow-display', true
  end

  def test_show_by_manager_without_permission
    get :show, :id => 1
    assert_response :success
    assert_template 'show'

    assert_equal Issue.find(1), assigns(:issue)

    # test if standard Redmine stuff is there (i.e. render_super() works)
    assert_select 'a', :text => /Quote/
    assert_select 'form#issue-form', true
    assert_select '#issue_tracker_id', true

    # test if workflow visualization is there
    assert_select '#workflow-display', false
  end
end
