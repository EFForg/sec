module FormHelper
  def check_mark_tag(name, label)
    render "shared/check_mark", name: name, label: label
  end
end
