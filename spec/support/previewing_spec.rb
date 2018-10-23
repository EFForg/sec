require 'rails_helper'

shared_examples_for 'previewable' do |params, ignored = []|
  let(:saved) { FactoryGirl.create(described_class.to_s.underscore) }
  it 'returns model object with new attributes' do
    original_attributes = saved.attributes
    preview = saved.preview(params)
    expect(preview).to have_attributes(original_attributes.merge(params))
    expect(strip_attributes(saved.reload.attributes, ignored)).to \
      eq(strip_attributes(original_attributes, ignored))
  end
end

shared_examples_for 'previewable with children' do |params, child, association,
                                                    ignored|
  let(:saved_child) { FactoryGirl.create(child.to_s.underscore) }
  let(:saved) do 
    FactoryGirl.create(described_class.to_s.underscore,
                       association => [saved_child])
  end
  it 'returns model object with new attributes' do
    original_attributes = saved_child.attributes
    params = sub_id_in_params(params, saved_child.id)
    preview = saved.preview(params)
    child_attrs = params["#{association}_attributes"].values.first
    expect(preview[1][0]).to \
      have_attributes(strip_attributes(original_attributes.merge(child_attrs),
                                       ignored))
    expect(strip_attributes(saved_child.reload.attributes, ignored)).to \
      eq(strip_attributes(original_attributes, ignored))
  end

  def sub_id_in_params(params, real_id)
    association_attributes = params.keys.first
    key = params[association_attributes].keys.first
    params[association_attributes][key]['id'] = real_id
    params
  end
end

def strip_attributes(attrs, to_remove = [])
  to_remove << 'created_at' << 'updated_at'
  to_remove.each { |a| attrs.delete a }
  attrs
end
