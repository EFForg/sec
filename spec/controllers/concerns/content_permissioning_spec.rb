require 'rails_helper'

RSpec.describe ContentPermissioning, type: :controller do
  controller_class = Class.new(ApplicationController) do
    include ContentPermissioning
  end

  let(:controller) { controller_class.new }
  let(:record) { double }

  describe '#protect_unpublished!' do
    context 'user is an admin' do
      before do
        expect(controller).to receive(:current_admin_user){ true }.
                               at_least(:once)
      end

      it 'should not raise an error' do
        allow(record).to receive(:unpublished?){ true }
        expect{ controller.protect_unpublished!(record) }.not_to raise_error

        allow(record).to receive(:unpublished?){ false }
        expect{ controller.protect_unpublished!(record) }.not_to raise_error
      end
    end

    context 'user not is an admin' do
      before do
        expect(controller).to receive(:current_admin_user){ nil }.
                               at_least(:once)
      end

      it 'should raise an error if the record is unpublished' do
        expect(record).to receive(:unpublished?){ true }
        expect{ controller.protect_unpublished!(record) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should not raise an error if the record is published' do
        expect(record).to receive(:unpublished?){ false }
        expect{ controller.protect_unpublished!(record) }.not_to raise_error
      end
    end
  end
end
