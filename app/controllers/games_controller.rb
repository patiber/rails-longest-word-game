require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    grid_array = []
    i=0

    while i < 10
      grid_array << ('a'..'z').to_a.sample
      i+=1
    end
    @letters = grid_array
  end

  def score
    result = {}
    attempt = params["word"]
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    @user = JSON.parse(user_serialized)
    score_bad = 0
    grid = params["letters"].split(" ")

    if @user["found"] == true
      if word_in_grid?(attempt, grid)
        score_good = 10
        score_good += 10 if attempt.size > 4
        score_good += 10 # if (end_time - start_time) < 10
        result.store(:score, score_good)
        result.store(:message, "Congratulations! #{attempt} is a valid English word!")
        # result.store(:time, (end_time - start_time))
      else
        result.store(:score, score_bad)
        result.store(:message, "Sorry but #{attempt} is not in the grid!")
      end
    else
      result.store(:score, score_bad)
      result.store(:message, "Sorry but #{attempt} is not a valid english word!")
    end
    @score = result
  end

    def word_in_grid?(attempt, grid_array)
      grid_array.map! { |letter| letter.downcase }
      attempt.chars.each do |letter|
        if grid_array.include?(letter)
          grid_array.delete_at(grid_array.index(letter))
        else
          return false
        end
      end
      return true
    end
end
