module WorkflowEnhancements::Graph

	def self.load_data(roles, trackers)
    unless trackers && trackers.length == 1
      return { :nodes => [], :edges => [] }
    end
    tracker = trackers.first

    role_map = {}
    if roles
      roles.each {|x| role_map[x.id] = x }
    end

    states_array = tracker.issue_statuses.map do |s|
      { :id => s.id, :value => { :label => s.name } }
    end

    edges_map = {}
    WorkflowTransition.where(:tracker_id => tracker).each do |t|
      key = t.old_status_id.to_s + '-' + t.new_status_id.to_s
      own = role_map.include?(t.role_id)
      author = own && t.author
      assignee = own && t.assignee

      if edges_map.include?(key)
        edges_map[key][:own] ||= own
        edges_map[key][:author] ||= author
        edges_map[key][:assignee] ||= assignee
      else
        edges_map[key] = { :u => t.old_status_id, :v => t.new_status_id, :own => own }
      end
    end
    edges_array = []
    edges_map.each_value do |e|
      cls = 'transOther'
      if e[:own]
        cls = 'transOwn'
        cls += ' transOwn-author' if e[:author]
        cls += ' transOwn-assignee' if e[:assignee]
      end
      edges_array << { :u => e[:u], :v => e[:v], :value => { :edgeclass => cls } }
    end

    { :nodes => states_array, :edges => edges_array }
	end
end
