require File.expand_path('../../test_helper', __FILE__)

class TrackerStatusTest < ActiveSupport::TestCase
  context "relations" do
    should belong_to(:tracker)
    should belong_to(:predef_issue_status)
  end

  context "validations" do
    should validate_presence_of(:tracker)
    should validate_presence_of(:issue_status_id)

    subject { TrackerStatus.create(:tracker_id => 1, :issue_status_id => 1) }
    should validate_uniqueness_of(:issue_status_id).scoped_to(:tracker_id)
  end

  def test_new_tracker
    t = Tracker.new
    assert_equal [], t.issue_statuses
  end
end
