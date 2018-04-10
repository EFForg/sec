class UsePageForIndexPages < ActiveRecord::Migration[5.1]
  def up
    ["articles", "blog", "materials", "topics"].each do |region|
      page = Page.find_or_create_by!(name: "#{region}-overview")
      managed_content = ManagedContent.find_by(region: "#{region}-intro")
      if managed_content
        page.update!(body: managed_content.body)
        managed_content.destroy!
      else
        page.update!(
          body: %(Intro text to #{region}. Edit me <a href="/admin/#{region}_overview">here</a>.)
        )
      end
    end

    credits_page = Page.find_or_create_by!(name: "credits")
    credits_content = ManagedContent.find_by(region: "credits")
    if credits_content
      credits_page.update!(body: credits_content.body)
      credits_content.destroy!
    end

    change_column :pages, :body, :text, null: false, default: ""
  end

  def down
    ["articles", "blog", "materials", "topics"].each do |region|
      managed_content = ManagedContent.find_or_create_by!(region: "#{region}-intro")
      page = Page.find_by(name: "#{region}-overview")
      if page
        managed_content.update!(body: managed_content.body)
        page.destroy!
      else
        managed_content.update!(
          body: %(Intro text to #{region}. Edit me <a href="/admin/#{region}_overview">here</a>.)
        )
      end
    end
      
    credits_content = ManagedContent.find_or_create_by!(region: "credits")
    credits_page = Page.find_by(name: "credits")
    if credits_page
      credits_content.update!(body: credits_content.body)
      credits_page.destroy!
    end

    change_column :pages, :body, :text, null: true
  end

  class ManagedContent < ApplicationRecord
    self.table_name = :managed_content
  end
end
