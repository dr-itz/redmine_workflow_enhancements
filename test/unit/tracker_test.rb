require File.expand_path('../../test_helper', __FILE__)

class TrackerTest < ActiveSupport::TestCase
  context "relations" do
    should have_many(:tracker_statuses)
    should have_many(:predef_issue_statuses).through(:tracker_statuses)
  end

  context "issue_statuses" do
    def test_default_behaviour
      tracker = Tracker.find(1)
      WorkflowTransition.delete_all
      WorkflowTransition.create!(:role_id => 1, :tracker_id => 1, :old_status_id => 2, :new_status_id => 3)
      WorkflowTransition.create!(:role_id => 2, :tracker_id => 1, :old_status_id => 3, :new_status_id => 5)

      assert_kind_of Array, tracker.issue_statuses
      assert_kind_of IssueStatus, tracker.issue_statuses.first
      assert_equal [2, 3, 5], Tracker.find(1).issue_statuses.collect(&:id)
    end

    def test_should_be_empty_for_new_record
      assert_equal [], Tracker.new.issue_statuses
    end

    def test_predef_statuses
      WorkflowTransition.delete_all
      tracker = Tracker.find(1)
      tracker.predef_issue_status_ids = [1, 6]
      assert_kind_of Array, tracker.issue_statuses
      assert_kind_of IssueStatus, tracker.issue_statuses.first
      assert_equal [1, 6], Tracker.find(1).issue_statuses.collect(&:id)
    end

    def test_predef_statuses_and_workflow
      tracker = Tracker.find(1)
      tracker.predef_issue_status_ids = [1, 6]
      assert_kind_of Array, tracker.issue_statuses
      assert_kind_of IssueStatus, tracker.issue_statuses.first
      assert_equal [1, 2, 3, 4, 5, 6], Tracker.find(1).issue_statuses.collect(&:id)
    end
  end
end

