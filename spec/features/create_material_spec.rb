require 'rails_helper'

RSpec.feature "UploadMaterial", type: :feature, js: true do
  let(:admin){ FactoryGirl.create(:admin_user) }
  before{ login(admin) }

  scenario "admin user creates a new material" do
    visit new_admin_material_path

    fill_in "Name", with: "New material"

    click_on "Add New Upload"

    within(:css, ".uploads fieldset") do
      fill_in "Name", with: "An upload"

      attach_file "File", file_fixture("image.gif")
    end

    expect {
      click_on "Create Material"
      expect(page).to have_current_path(admin_materials_path)
    }.to change(Material, :count).by(1)

    material = Material.order(id: :desc).take
    upload = material.uploads.take

    expect(upload).to be_present
    expect(upload.file).to be_present
    expect(upload.file.full_preview).to be_present
    expect(upload.file.thumbnail).to be_present
  end
end
