# frozen_string_literal: true

RSpec.describe Waylon::Wordle do
  it "has a version number" do
    expect(Waylon::Wordle::VERSION).not_to be nil
  end

  it "loads the answers" do
    expect(Waylon::Wordle.answers).to be_an(Array)
    expect(Waylon::Wordle.answers.first).to eq("cigar")
  end
end
