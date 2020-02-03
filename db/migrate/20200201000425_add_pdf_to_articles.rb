class AddPdfToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :pdf, :string
  end
end
