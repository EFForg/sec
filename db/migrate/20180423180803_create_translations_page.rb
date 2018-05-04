class CreateTranslationsPage < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up{ Page.create(name: "translations") }
      dir.down{ Page.where(name: "translations").destroy_all }
    end
  end
end
