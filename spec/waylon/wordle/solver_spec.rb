# frozen_string_literal: true

RSpec.describe Waylon::Wordle::Solver do
  subject do
    described_class.new("audio")
  end

  it "attempts to find answers" do
    solution = subject.solve_todays_wordle
    expect(solution).to be_an(Array)
    expect(solution.size).to be <= 6
  end
end
