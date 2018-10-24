module ApplicationHelper
  def page_title
    if @page_title.present?
      "#{@page_title} | Security Education Companion"
    elsif breadcrumbs.present?
      "#{breadcrumb_names.last} | Security Education Companion"
    else
      "Security Education Companion"
    end
  end

  def link_with_aria_current(text, path)
    if current_page? path
      link_to text, path, "aria-current" => "page"
    else
      link_to text, path
    end
  end

  def matomo_url
    "https://anon-stats.eff.org/js/?" + {
      idsite: 28,
      rec: 1,
      action_name: page_title,
      url: request.original_url
    }.to_param
  end

  def modal(name = nil, &block)
    unless name && session.fetch(:dismissed_modals, []).include?(name)
      render "shared/modal", name: name, &block
    end
  end
end
