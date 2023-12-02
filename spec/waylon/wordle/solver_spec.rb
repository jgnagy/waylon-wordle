# frozen_string_literal: true

RSpec.describe Waylon::Wordle::Solver do
  subject do
    described_class.new("audio")
  end

  it "attempts to find answers" do
    allow(Waylon::Wordle).to receive(:for_today).and_return("audit")
    subject.solve_todays_wordle
    solution = subject.attempts
    expect(solution).to be_an(Array)
    expect(solution.size).to be <= 6
    expect(solution.last[:word]).to eq("audit")
    expect(solution.last[:result]).to eq(%i[hit hit hit hit hit])
  end
end
