require File.expand_path('../../test_helper', __FILE__)

class GraphTest < ActionView::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :workflows

  include ActionView::TestCase::Behavior

  def setup
    @tracker_bug = Tracker.find(1)
    @role_manager   = Role.find(1)
    @role_reporter  = Role.find(3)
    @role_nonmember = Role.find(4)
    @issue = Issue.find(1)

    @bug_states = [
      { :id => 1, :value => { :label => "New",      :nodeclass => "state-new" }},
      { :id => 2, :value => { :label => "Assigned", :nodeclass => "" }},
      { :id => 3, :value => { :label => "Resolved", :nodeclass => "" }},
      { :id => 4, :value => { :label => "Feedback", :nodeclass => "" }},
      { :id => 5, :value => { :label => "Closed",   :nodeclass => "state-closed" }},
      { :id => 6, :value => { :label => "Rejected", :nodeclass => "state-closed" }}]

    @bug_states_issue = [
      { :id => 1, :value => { :label => "New",      :nodeclass => "state-new state-current" }},
      { :id => 2, :value => { :label => "Assigned", :nodeclass => " state-possible" }},
      { :id => 3, :value => { :label => "Resolved", :nodeclass => "" }},
      { :id => 4, :value => { :label => "Feedback", :nodeclass => "" }},
      { :id => 5, :value => { :label => "Closed",   :nodeclass => "state-closed" }},
      { :id => 6, :value => { :label => "Rejected", :nodeclass => "state-closed" }}]

    @bug_transition_all = [
      { :u => 1, :v => 2, :value => { :edgeclass => "" }},
      { :u => 2, :v => 1, :value => { :edgeclass => "" }},
      { :u => 2, :v => 3, :value => { :edgeclass => "" }},
      { :u => 3, :v => 2, :value => { :edgeclass => "" }},
      { :u => 3, :v => 5, :value => { :edgeclass => "" }},
      { :u => 3, :v => 4, :value => { :edgeclass => "" }},
      { :u => 4, :v => 2, :value => { :edgeclass => "" }},
      { :u => 4, :v => 5, :value => { :edgeclass => "" }},
      { :u => 2, :v => 6, :value => { :edgeclass => "" }}]

    @bug_transition_manager = Marshal.load(Marshal.dump(@bug_transition_all))
    @bug_transition_manager.each {|x| x[:value][:edgeclass] = 'transOwn' }

    @bug_transition_reporter = [
      { :u => 1, :v => 2, :value => { :edgeclass => "transOther" }},
      { :u => 2, :v => 1, :value => { :edgeclass => "transOther" }},
      { :u => 2, :v => 3, :value => { :edgeclass => "transOwn transOwn-assignee" }},
      { :u => 3, :v => 2, :value => { :edgeclass => "transOther" }},
      { :u => 3, :v => 5, :value => { :edgeclass => "transOther" }},
      { :u => 3, :v => 4, :value => { :edgeclass => "transOther" }},
      { :u => 4, :v => 2, :value => { :edgeclass => "transOwn transOwn-author" }},
      { :u => 4, :v => 5, :value => { :edgeclass => "transOwn transOwn-author" }},
      { :u => 2, :v => 6, :value => { :edgeclass => "transOther" }}]

    @bug_transition_nonmember = Marshal.load(Marshal.dump(@bug_transition_all))
    @bug_transition_nonmember.each {|x| x[:value][:edgeclass] = 'transOther' }
  end

  def test_empty_data
    result = WorkflowEnhancements::Graph.load_data(nil, nil)
    assert_equal({ :nodes => [], :edges => [] }, result)
  end

  def test_empty_data_array
    result = WorkflowEnhancements::Graph.load_data([], [])
    assert_equal({ :nodes => [], :edges => [] }, result)
  end

  def test_multiple_trackers
    #trackers = Tracker.all
    #result = WorkflowEnhancements::Graph.load_data(nil, trackers)
    #assert_equal({ :nodes => [], :edges => [] }, result)
  end

  def test_with_tracker_bug_all
    result = WorkflowEnhancements::Graph.load_data(nil, @tracker_bug)
    assert result.has_key? :nodes
    assert result.has_key? :edges
    assert_equal @bug_states, result[:nodes]
    assert_equal @bug_transition_all, result[:edges]
  end

  def test_with_tracker_bug_all_empty_array
    result = WorkflowEnhancements::Graph.load_data([], @tracker_bug)
    assert_equal @bug_states, result[:nodes]
    assert_equal @bug_transition_all, result[:edges]
  end

  def test_with_tracker_bug_manager
    result = WorkflowEnhancements::Graph.load_data(@role_manager, @tracker_bug)
    assert_equal @bug_states, result[:nodes]
    assert_equal @bug_transition_manager, result[:edges]
  end

  def test_with_tracker_bug_manager_issue
    User.current = User.find(2) # manager

    result = WorkflowEnhancements::Graph.load_data(@role_manager, @tracker_bug, @issue)
    Rails.logger.warn result[:nodes].inspect
    assert_equal @bug_states_issue, result[:nodes]
    assert_equal @bug_transition_manager, result[:edges]
  end

  def test_with_tracker_bug_reporter
    result = WorkflowEnhancements::Graph.load_data(@role_reporter, @tracker_bug)
    assert_equal @bug_states, result[:nodes]
    assert_equal @bug_transition_reporter, result[:edges]
  end

  def test_with_tracker_bug_nonmember
    result = WorkflowEnhancements::Graph.load_data(@role_nonmember, @tracker_bug)
    assert_equal @bug_states, result[:nodes]
    assert_equal @bug_transition_nonmember, result[:edges]
  end
end
