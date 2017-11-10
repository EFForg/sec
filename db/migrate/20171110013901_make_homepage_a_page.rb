class MakeHomepageAPage < ActiveRecord::Migration[5.1]
  def up
    old_homepage = Homepage.first_or_create!
    new_homepage = Page.find_or_create_by!(name: "homepage")
    ["articles", "blog", "materials", "lessons"].each do |region|
      ManagedContent.create!(region: "homepage-#{region}-intro",
                             page: new_homepage,
                             body: old_homepage.send("#{region}_intro") || "")
    end
    ManagedContent.create!(region: "welcome",
                           page: new_homepage,
                           body: old_homepage.welcome || "")
    ManagedContent.create!(region: "update_notes",
                           page: new_homepage,
                           body: old_homepage.update_notes || "")
    drop_table :homepages
  end

  def down
    create_table :homepages do |t|
      t.text :welcome, default: "", null: false
      t.text :articles_intro, default: "",  null: false
      t.text :lessons_intro, default: "", null: false
      t.text :blog_intro, default: "", null: false
      t.text :materials_intro, default: "", null: false
      t.text :update_notes, default: "", null: false

      t.timestamps
    end

    Homepage.create!(
      welcome: ManagedContent.find_by(region: "welcome").body || "",
      articles_intro: ManagedContent.find_by(region: "homepage_articles_intro").body || "",
      lessons_intro: ManagedContent.find_by(region: "homepage_lessons_intro").body || "",
      blog_intro: ManagedContent.find_by(region: "homepage_blog_intro").body || "",
      materials_intro: ManagedContent.find_by(region: "homepage_materials_intro").body || "",
      update_notes: ManagedContent.find_by(region: "update_notes").body || ""
    )

    old_homepage = Page.find_by(name: "homepage")
    if old_homepage
      ManagedContent.where(page: old_homepage).destroy_all
      old_homepage.destroy!
    end
  end
end
