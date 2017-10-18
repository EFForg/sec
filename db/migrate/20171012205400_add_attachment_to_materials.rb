class AddAttachmentToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :attachment, :string
    remove_column :materials, :attachment_file_name, :string
    remove_column :materials, :attachment_content_type, :string
    remove_column :materials, :attachment_file_size, :integer
    remove_column :materials, :attachment_updated_at, :datetime
  end
end
