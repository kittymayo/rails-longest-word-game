require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { [*('A'..'Z')].sample }.join
  end

  def score
    result = {}
    letters = params[:letters]
    answer = params[:answer]
    if array_comparison?(answer, letters) && a_real_word?(answer)
      result[:score] = answer.length.to_i
      result[:message] = "Well done! Your score is #{result[:score]}!"
    elsif a_real_word?(answer) == false
      result[:score] = 0
      result[:message] = "#{answer.upcase} is not an english word. Score is #{result[:score]}!"
    elsif array_comparison?(answer, letters) == false
      result[:score] = 0
      result[:message] = "Sorry but #{answer.upcase} cannot be made from the letters. Score is #{result[:score]}!"
    end
    @response = result[:message]
  end

  def array_comparison?(answer, letters)
    answer.chars.all? do |letter|
      letters.count(letter.upcase) >= answer.upcase.count(letter.upcase)
    end
  end

  def a_real_word?(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    dictionary_serialized = open(url).read
    reference = JSON.parse(dictionary_serialized)
    return reference['found']
  end
end
