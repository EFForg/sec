require_dependency "matomo"
ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: "Dashboard" do
    columns do
      column do
        render partial: "admin/dashboard/top_pages",
          locals: {title: "Top Articles This Month", pages: Matomo.top_articles}
      end

      column do
        render partial: "admin/dashboard/top_pages",
          locals: {title: "Top Lesson Topics This Month", pages: Matomo.top_lesson_topics}
      end
    end
  end
end
