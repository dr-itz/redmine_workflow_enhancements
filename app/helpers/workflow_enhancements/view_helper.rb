module WorkflowEnhancements::ViewHelper

  def render_super(current_path)
    details = lookup_context.registered_details.inject({}) do |h, n|
      h[n] = lookup_context.send(n); h
    end
    details[:locale] = [details[:locale]] unless details[:locale].is_a? Array

    parent_views = view_paths.map do |path|
      path.find_all(File.basename(current_path).split('.').first,
        lookup_context.prefixes.first, false, details).first.try(:identifier)
    end.compact.delete_if {|path| !path || path == current_path}
    render :file => parent_views.first.split('.').first
  end
end
