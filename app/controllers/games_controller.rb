require 'open-uri'
require 'json'

# before_action

class GamesController < ApplicationController
  def new
    @grid = []
    letters = ('A'..'Z').to_a
    10.times do
      @grid << letters.sample
    end
    @grid
  end

  def check_dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result = open(url).read
    result_hash = JSON.parse(result)
    result_hash["found"]
  end

  def check_grid?
    new_grid = params[:grid].split("")
    params[:word].split('').each do |letter|
      if new_grid.include?(letter) == true
        new_grid.delete_at(new_grid.index(letter))
      else
        return false
      end
    end
    true
  end

  def compute_score(word_length)
    word_length * word_length
  end

# if I write @score = 0, @message = bla, it returns an array like [4, "Well Done!"]
  def score
    word_length = params[:word].length
    if check_dictionary?(params[:word]) == false
      @score = 0
      @message = "Sorry, but '#{params[:word].upcase}' is not an English word. Your score is #{@score}."
    elsif params[:word].length.zero?
      @score = 0
      @message = "Please enter a word."
    elsif check_grid? == false
      @score = 0
      @message = "Sorry, but '#{params[:word].upcase}' cannot be built out of #{params[:grid]}. Your score is #{@score}."
    else
      @score = compute_score(word_length)
      @message = "Congratulations! #{params[:word].upcase} is a valid English word! Your score is #{@score}."
    end
  end
end
