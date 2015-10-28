module WorkflowEnhancements::Graph

	def self.load_data(roles, trackers, issue=nil)
    tracker = nil
    if trackers.is_a?(Array)
      tracker = trackers.length == 1 ? trackers.first : nil
    else
      tracker = trackers
    end
    unless tracker
      return { :nodes => [], :edges => [] }
    end

    current_status = nil
    possible_statuses = {}
    if issue
      current_status = issue.status_id
      issue.new_statuses_allowed_to().each {|x| possible_statuses[x.id] = true }
    end

    role_map = {}
    Array(roles).each {|x| role_map[x.id] = x } if roles

    new_issue_status_map = {}
    edges_map = {}
    WorkflowTransition.where(:tracker_id => tracker).each do |t|
      if t.old_status_id != 0
        key = t.old_status_id.to_s + '-' + t.new_status_id.to_s
        own = role_map.include?(t.role_id)
        author = own && t.author
        assignee = own && t.assignee
        always = own && !author && !assignee

        if edges_map.include?(key)
          edges_map[key][:own] ||= own
          edges_map[key][:author] ||= author
          edges_map[key][:assignee] ||= assignee
          edges_map[key][:always] ||= always
        else
          edges_map[key] = { :u => t.old_status_id, :v => t.new_status_id,
             :own => own, :author => author, :assignee => assignee, :always => always }
        end
      else
        new_issue_status_map[t.new_status_id] = 1
      end
    end
    edges_array = []
    edges_map.each_value do |e|
      cls = role_map.empty? ? '' : 'transOther'
      if e[:own]
        cls = 'transOwn'
        unless e[:always]
          cls += ' transOwn-author' if e[:author]
          cls += ' transOwn-assignee' if e[:assignee]
        end
      end
      edges_array << { :u => e[:u], :v => e[:v], :value => { :edgeclass => cls } }
    end

    statuses_array = tracker.issue_statuses.map do |s|
      cls = ''
      if is_default_status(tracker, s)
        cls = 'state-new'
      elsif new_issue_status_map.include?(s.id)
        cls = 'state-new-possible'
      elsif s.is_closed
        cls = 'state-closed'
      end
      if s.id == current_status
        cls += ' state-current'
      elsif possible_statuses.include?(s.id)
        cls += ' state-possible'
      end
      { :id => s.id, :value => { :label => s.name, :nodeclass => cls } }
    end

    { :nodes => statuses_array, :edges => edges_array }
	end

  private

  def self.is_default_status(tracker, status)
    if Redmine::VERSION::MAJOR == 3
      tracker.default_status == status
    else
      status.is_default
    end
  end
end
