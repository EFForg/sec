class CreateManagedContentForSectionIntros < ActiveRecord::Migration[5.1]
  def change
    ["articles", "blog", "materials", "topics"].each do |region|
      content = ManagedContent.find_or_create_by!(region: "#{region}-intro")
      content.update!(
        body: %(Intro text to #{region}. Edit me <a href="/admin/#{region}_overview">here</a>.)
      )
    end
  end
end
