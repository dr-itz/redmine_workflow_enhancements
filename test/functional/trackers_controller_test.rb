require File.expand_path('../../test_helper', __FILE__)

class TrackersControllerTest < ActionController::TestCase
  fixtures :roles, :trackers, :workflows, :users, :issue_statuses

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_get_edit
    Tracker.find(1).predef_issue_status_ids = [1, 3]

    get :edit, :id => 1
    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tracker)

    # test if standard Redmine stuff is there (i.e. render_super() works)
    assert_select '#tracker_name', true

    # test if workflow visualization is there
    assert_select 'svg#workflow-vis', true

    # test if the issue status selectino is there
    assert_select '#predef-statuses', true

    assert_select 'input[name=?][value="1"][checked=checked]', 'tracker[predef_issue_status_ids][]'
    assert_select 'input[name=?][value="3"][checked=checked]', 'tracker[predef_issue_status_ids][]'
  end

  def test_create_with_predef_statuses
    assert_difference 'Tracker.count' do
      post :create, :tracker => {
        :name => 'New tracker',
        :default_status_id => 1,
        :predef_issue_status_ids => ['1', '2', '3', '5'] }
    end
    assert_redirected_to :action => 'index'

    tracker = Tracker.order('id DESC').first
    assert_equal 'New tracker', tracker.name
    assert_equal 0, tracker.workflow_rules.count
    assert_equal 4, tracker.predef_issue_statuses.count
  end

  def test_updat_with_predef_statusese
    put :update, :id => 1, :tracker => {
      :name => 'Renamed',
      :predef_issue_status_ids => ['3', '5'] }
    assert_redirected_to :action => 'index'
    assert_equal [3, 5], Tracker.find(1).predef_issue_status_ids.sort
  end
end
