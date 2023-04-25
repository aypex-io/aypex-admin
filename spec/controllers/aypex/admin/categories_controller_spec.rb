require "spec_helper"

describe Aypex::Admin::CategoriesController, type: :controller do
  stub_authorization!

  describe "#remove_icon" do
    let(:store) { Aypex::Store.default }
    let!(:base_category) { create(:base_category, store: store) }
    let!(:category) { create(:category, base_category: base_category) }
    let!(:category_image) { Aypex::Image.new }
    let!(:image_file) { File.open(Aypex::Engine.root + "spec/fixtures" + "thinking-cat.jpg") }

    before do
      allow_any_instance_of(described_class).to receive(:current_store).and_return(store)
      category_image.attachment.attach(io: image_file, filename: "thinking-cat.jpg", content_type: "image/jpeg")
      category.image = category_image
      category.save!
    end

    it "should remove current store category icon" do
      expect(category.image).to eq(category_image)

      allow(category).to receive :remove_icon
      post :remove_icon, params: {base_category_id: base_category.id, id: category.id}
      category.reload

      expect(category.image).to eq(nil)
    end

    context "when different current store" do
      let!(:second_store) { create(:store) }
      let(:request) { post :remove_icon, params: {base_category_id: base_category.id, id: category.id} }

      before do
        allow_any_instance_of(described_class).to receive(:current_store).and_return(second_store)
      end

      it "should not find base_category" do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
