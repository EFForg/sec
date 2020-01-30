ActiveAdmin.register_page "Export" do
  controller { include Zipping }

  page_action :zip, method: :post do
    send_file(
      MarkdownArchive.new.zip,
      filename: "sec.eff.org-#{Time.now.strftime('%Y-%m-%d')}.zip"
    )
  end

  action_item :add do
    link_to "Markdown/zip archive",
            admin_export_zip_path, method: :post
  end
end
