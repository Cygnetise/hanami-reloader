# frozen_string_literal: true

RSpec.describe "Hanami::Reloader::VERSION" do
  it "exposes version" do
    expect(Hanami::Reloader::VERSION).to eq("2.1.0.rc1")
  end
end
