# frozen_string_literal: true

require "date"
require "json"

require "waylon/core"
require_relative "wordle/version"

module Waylon
  # The Wordle module for Waylon
  module Wordle
    class Error < StandardError; end
    # Your code goes here...

    def self.answers_file
      # First, try the official data path for the gem, then pull from a relative path
      relative_path = if File.exist?(Gem.datadir("waylon-wordle"))
                        Gem.datadir("waylon-wordle")
                      else
                        File.join(
                          File.dirname(__FILE__), "..", "..", "data"
                        )
                      end
      File.expand_path(File.join(relative_path, "answers.json"))
    end

    def self.answers
      @answers ||= JSON.load_file(answers_file)
    end

    def self.random_startword
      answers.select { |word| word.chars.intersection(%w[a e i o u]).uniq.size >= 3 }.sample
    end

    def self.todays_number
      (Date.today - Date.new(2021, 6, 19)).to_i
    end

    def self.for_today
      answers[todays_number]
    end
  end
end

require_relative "wordle/solver"
require_relative "skills/wordle"
