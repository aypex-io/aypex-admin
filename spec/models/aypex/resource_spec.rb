require "spec_helper"

module Aypex
  class Test
  end

  module Submodule
    class Test
    end
  end
end

module Aypex
  module Admin
    describe Resource, type: :model do
      let(:resource_base) { Resource.new("aypex/admin/test", "test", "widget") }
      let(:resource_submodule) { Resource.new("aypex/admin/submodule/test", "test", "widget") }
      let(:resource_object_name) { Resource.new("aypex/admin/test", "test", "gadget", "widget") }

      it "can get base model class" do
        expect(resource_base.model_class).to eq(Aypex::Test)
      end

      it "can get submodule class" do
        expect(resource_submodule.model_class).to eq(Aypex::Submodule::Test)
      end

      it "can get base model name (only used for parent)" do
        expect(resource_base.model_name).to eq("widget")
      end

      it "can get submodule model name (only used for parent)" do
        expect(resource_submodule.model_name).to eq("widget")
      end

      it "can get base object name" do
        expect(resource_base.object_name).to eq("test")
      end

      it "can get submodule object name" do
        expect(resource_submodule.object_name).to eq("submodule_test")
      end

      it "can get overridden object name" do
        expect(resource_object_name.object_name).to eq("widget")
      end
    end
  end
end
