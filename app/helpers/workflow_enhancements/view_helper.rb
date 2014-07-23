module WorkflowEnhancements::ViewHelper

	def render_super(current_path)
		details = lookup_context.registered_details.inject({}) do |h, n|
			h[n] = lookup_context.send(n); h
		end
		details[:locale] = [details[:locale]] unless details[:locale].is_a? Array

		parent_view = view_paths.map do |path|
			path.find_all(File.basename(current_path).split('.').first,
         lookup_context.prefixes.first, false, details).first.try(:identifier)
		end.compact.drop_while {|path| path != current_path}[1].split('.').first
		render :file => parent_view
  end

end
