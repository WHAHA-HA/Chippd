class AdminTable < TableCloth::Base
  # Force actions to last column.
  def columns
    if @reordered
      @reordered
    else
      super
      actions_hash = @columns.select { |k, v| k == :actions }
      @reordered = @columns.select { |k, v| k != :actions }
      @reordered[:actions] = actions_hash[:actions]
      @reordered
    end
  end

  actions do
    action {|object, view| view.link_to_toggle_visibility(object) }
    action {|object, view| view.link_to_edit(object) }
    action {|object, view| view.link_to_destroy(object) }
  end
end