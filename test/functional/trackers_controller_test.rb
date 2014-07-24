require File.expand_path('../../test_helper', __FILE__)

class TrackersControllerTest < ActionController::TestCase
  fixtures :roles, :trackers, :workflows, :users, :issue_statuses

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_get_edit
    get :edit, :id => 1
    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tracker)

    # test if standard Redmine stuff is there (i.e. render_super() works)
    assert_select '#tracker_name', true

    # test if workflow visualization is there
    assert_select 'svg#workflow-vis', true
  end
end
