class TrackerStatus < ActiveRecord::Base
  unloadable

  belongs_to :tracker
  belongs_to :predef_issue_status, :class_name => 'IssueStatus', :foreign_key => 'issue_status_id'

  validates :tracker_id,      :presence => true
  validates :issue_status_id, :presence => true
  validates :issue_status_id, :uniqueness => { :scope => :tracker_id  }
end
