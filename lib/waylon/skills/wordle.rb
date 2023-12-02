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
        case solution.attempts.size
        when 1..2
          reply("I got *really* lucky today!")
        when 3
          reply("I did pretty well.")
        when 4..5
          reply("I managed to figure it out.")
        when 6
          if solution.last_attempted_word == Waylon::Wordle.for_today
            reply("I barely solved it!")
          else
            reply("Unfortunately, I didn't solve it.")
          end
        end

        reply(formatted_wordle_score(solution.attempts.map { _1[:result] }))
      end

      def spoil_wordle
        threaded_reply("Here's what my attempt looked like...")
        threaded_reply(
          codify(
            JSON.pretty_generate(solve_todays_wordle.attempts.map { |w| w[:word].upcase })
          )
        )
      end

      private

      def formatted_wordle_score(scores)
        translation = {
          miss: "⬛",
          hit: "🟩",
          near_hit: "🟨"
        }

        solved_in = scores.last.map(&:to_sym) == %i[hit hit hit hit hit] ? scores.size : "X"

        lines = ["Wordle #{Waylon::Wordle.todays_number} #{solved_in}/6"]
        lines << ""
        scores.each do |score|
          lines << score.map { translation[_1.to_sym] }.join
        end
        lines.join("\n")
      end

      def solve_todays_wordle
        cache("solution_#{DateTime.now.new_offset("-05:00").to_date}", expires: 24 * 60 * 60) do
          solver = Waylon::Wordle::Solver.new(Waylon::Wordle.random_startword)
          solver.solve_todays_wordle
          solver
        end
      end
    end
  end
end
