# frozen_string_literal: true

RSpec.describe Waylon::Wordle do
  it "has a version number" do
    expect(Waylon::Wordle::VERSION).not_to be nil
  end

  it "loads the vocabulary" do
    expect(Waylon::Wordle.vocabulary).to be_an(Array)
    expect(Waylon::Wordle.vocabulary.first).to eq("aahed")
    expect(Waylon::Wordle.vocabulary.last).to eq("zymic")
  end
end
