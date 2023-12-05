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

    def self.vocabulary_file
      # First, try the official data path for the gem, then pull from a relative path
      relative_path = if File.exist?(Gem.datadir("waylon-wordle"))
                        Gem.datadir("waylon-wordle")
                      else
                        File.join(
                          File.dirname(__FILE__), "..", "..", "data"
                        )
                      end
      File.expand_path(File.join(relative_path, "vocabulary.json"))
    end

    def self.vocabulary
      @vocabulary ||= JSON.load_file(vocabulary_file)
    end

    def self.random_startword
      vocabulary.select do |word|
        if rand(10) > 5
          word.chars.uniq.intersection(%w[a e i o u]).uniq.size >= 4
        else
          word.chars.uniq.intersection(%w[a e o s t r n]).uniq.size >= 4
        end
      end.sample
    end

    def self.todays_date
      DateTime.now.new_offset("-05:00").to_date
    end

    def self.todays_number
      (todays_date - Date.new(2021, 6, 19)).to_i
    end

    def self.data_for_today
      conn = Faraday.new(
        headers: {
          "User-Agent": "Waylon/Wordle",
          accept: "application/json",
          "Accept-Language": "en-US,en;q=0.5",
          referer: "https://www.nytimes.com/games/wordle/index.html"
        }
      )
      response = conn.get("https://www.nytimes.com/svc/wordle/v2/#{todays_date}.json")

      JSON.parse(response.body)
    end

    def self.for_today
      data_for_today["solution"]
    end
  end
end

require_relative "wordle/solver"
require_relative "skills/wordle"
