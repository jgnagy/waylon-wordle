# frozen_string_literal: true

module Waylon
  module Wordle
    # Utility class for solving Wordle puzzles
    class Solver
      attr_reader :startword

      def initialize(startword)
        @startword = startword
      end

      def solve_todays_wordle
        answer = Waylon::Wordle.for_today.chars
        attempts = [startword.chars]
        attempts << make_attempt(answer, attempts) until attempts.last == answer || attempts.size == 6
        attempts
      end

      def make_attempt(answer, attempts)
        hits = []
        near_hits = []
        misses = []

        attempts.each do |attempt|
          attempt.each_with_index do |letter, index|
            if letter == answer[index]
              hits[index] = letter
            elsif answer.include?(letter) && hits.count(letter) < answer.count(letter)
              near_hits[index] ||= []
              near_hits[index] << letter
            else
              misses << letter unless misses.include?(letter)
            end
          end
        end

        find_potential_solution(hits, near_hits, misses)
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

      def find_potential_solution(hits, near_hits, misses)
        potential_solutions = Waylon::Wordle.vocabulary.map(&:chars).reject do |word|
          word.intersect?(misses)
        end

        potential_solutions.select do |word|
          hits_match?(hits, word) && near_hits_match?(near_hits, word)
        end.sample
      end
    end
  end
end
