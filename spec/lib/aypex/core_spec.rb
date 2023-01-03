require "spec_helper"

describe Aypex do
  describe ".admin_path" do
    it { expect(described_class.admin_path).to eq(Aypex.admin_path) }
  end

  describe ".admin_path=" do
    let!(:original_admin_path) { described_class.admin_path }
    let(:new_admin_path) { "/admin-secret-path" }

    before do
      described_class.admin_path = new_admin_path
    end

    after do
      described_class.admin_path = original_admin_path
    end

    it { expect(described_class.admin_path).to eq(new_admin_path) }
    it { expect(Aypex.admin_path).to eq(new_admin_path) }
  end
end
