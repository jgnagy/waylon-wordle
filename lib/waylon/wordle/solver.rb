# frozen_string_literal: true

module Waylon
  module Wordle
    # Utility class for solving Wordle puzzles
    class Solver
      attr_reader :startword, :answer
      attr_accessor :attempts, :hits, :near_hits, :misses

      def initialize(startword)
        @startword = startword
        @attempts = []
        @hits = []
        @near_hits = []
        @misses = []
        @answer = Waylon::Wordle.for_today.chars
      end

      def solve_todays_wordle
        until attempts.any? && (last_attempted_word == answer.join || attempts.size == 6)
          attempts << make_attempt(answer)
        end

        last_attempted_word == answer.join
      end

      def make_attempt(answer)
        word = next_word
        attempt = { word: word.join, result: [] }
        word.each_with_index do |letter, index|
          if letter == answer[index]
            add_hit(letter, index, attempt)
          elsif answer.include?(letter)
            add_near_hit(letter, index, word, attempt)
          else
            add_miss(letter, attempt)
          end
        end

        attempt
      end

      def find_potential_solution
        potential_solutions = Waylon::Wordle.vocabulary.map(&:chars).reject { _1.intersect?(misses) }

        candidates = potential_solutions.select do |word|
          hits_match?(hits, word) && near_hits_match?(near_hits, word)
        end

        candidates.shuffle.max_by { _1.uniq.size }
      end

      def last_attempted_word = attempts.last[:word]

      private

      def add_hit(letter, index, attempt)
        hits[index] = letter
        attempt[:result] << :hit
      end

      def add_near_hit(letter, index, word, attempt)
        near_hits[index] ||= []
        near_hits[index] << letter
        attempt[:result] << (counts_as_near_hit?(word, index) ? :near_hit : :miss)
      end

      def add_miss(letter, attempt)
        misses << letter unless misses.include?(letter)
        attempt[:result] << :miss
      end

      def next_word = attempts.empty? ? startword.chars : find_potential_solution

      def counts_as_near_hit?(word, index)
        return false unless answer.include?(word[index])

        answer_hit_count = answer.count(word[index])
        word_hits = word.each_with_index.with_object([]) do |(letter, idx), indices|
          indices << idx if letter == word[index] && answer[idx] == word[idx]
        end

        answer_hit_count > word_hits.size
      end

      def hits_match?(hits, exploded_word)
        hits.each_with_index do |letter, index|
          next unless letter

          return false unless exploded_word[index] == letter
        end

        true
      end

      def near_hits_match?(near_hits, exploded_word)
        near_hits.each_with_index do |letters, index|
          next unless letters && !letters.empty?

          return false if letters.include?(exploded_word[index])
          return false unless (letters - exploded_word).empty?
        end

        true
      end
    end
  end
end
