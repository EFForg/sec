module ApplicationHelper
  def page_title
    if @page_title.present?
      "#{@page_title} | TrainersHub"
    elsif breadcrumbs.present?
      "#{breadcrumbs.last[0]} | TrainersHub"
    else
      "TrainersHub"
    end
  end

  def materials_path
    "/materials"
  end
end
