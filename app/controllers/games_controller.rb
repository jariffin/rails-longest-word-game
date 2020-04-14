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
      @message = 'That is not an English word.'
    elsif check_grid? == false
      @score = 0
      @message = 'That word is not in the grid.'
    else
      @score = compute_score(word_length)
      @message = 'Well Done!'
    end
  end
end
