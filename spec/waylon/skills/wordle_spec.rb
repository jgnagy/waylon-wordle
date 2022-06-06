# frozen_string_literal: true

RSpec.describe Waylon::Skills::Wordle do
  it "solves some wordle" do
    send_message("How'd wordle go today?")
    expect(replies.last).to match(%r{^Wordle [0-9]+ ./6})
  end

  it "spoils wordle" do
    send_message("Spoil Wordle")
    expect(replies.last).to start_with("```\n[")
  end
end
