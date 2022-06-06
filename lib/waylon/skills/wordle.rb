# frozen_string_literal: true

module Waylon
  module Skills
    # A Waylon Skill for solving Wordle
    class Wordle < Waylon::Skill
      route(
        /.*spoil wordle.*/i,
        :spoil_wordle,
        help: {
          usage: "Spoil wordle for me",
          description: "Ask your to give you its method of answering today's Wordle"
        }
      )

      route(
        /.*wordle.*\?$/i,
        :todays_wordle,
        help: {
          usage: "Did you play wordle?",
          description: "Ask your bot about today's Wordle game"
        }
      )

      def todays_wordle
        solution = solve_todays_wordle
        case solution.size
        when 1..2
          reply("I got *really* lucky today!")
        when 3
          reply("I did pretty well.")
        when 4..5
          reply("I managed to figure it out.")
        when 6
          reply("I barely solved it!")
        else
          reply("Unfortunately, I didn't solve it.")
        end

        reply(formatted_wordle_score(solution))
      end

      def spoil_wordle
        threaded_reply("Here's what my attempt looked like...")
        threaded_reply(
          codify(
            JSON.pretty_generate(solve_todays_wordle.map { |w| w.join.upcase })
          )
        )
      end

      private

      def formatted_wordle_score(solution)
        miss = "⬛"
        hit = "🟩"
        near_hit = "🟨"
        todays_answer = Waylon::Wordle.for_today.chars
        solved_in = solution.include?(todays_answer) ? solution.size : "X"

        lines = ["Wordle #{Waylon::Wordle.todays_number} #{solved_in}/6"]
        lines << ""
        solution.each do |word|
          lines << word.map.with_index do |letter, index|
            if letter == todays_answer[index]
              hit
            elsif todays_answer.include?(letter)
              near_hit
            else
              miss
            end
          end.join
        end
        lines.join("\n")
      end

      def solve_todays_wordle
        cache("solution_#{Date.today}", expires: 24 * 60 * 60) do
          solver = Waylon::Wordle::Solver.new(Waylon::Wordle.random_startword)
          solver.solve_todays_wordle
        end
      end
    end
  end
end
