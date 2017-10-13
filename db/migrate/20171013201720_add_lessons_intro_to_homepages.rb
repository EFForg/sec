class AddLessonsIntroToHomepages < ActiveRecord::Migration[5.1]
  def change
    add_column :homepages, :lessons_intro, :text, null: false, default: ""
    add_column :homepages, :blog_intro, :text, null: false, default: ""
    add_column :homepages, :materials_intro, :text, null: false, default: ""
    change_column_default :homepages, :welcome, ""
    change_column_default :homepages, :articles_intro, ""
  end
end
