# frozen_string_literal: true

class Player
  attr_accessor :name
  def initialize
    @name = nil
  end

  def player_name
    puts 'What is your name?'
    @name = gets.chomp.downcase
  end

  def guess_letter
    puts 'Think of a letter...'
    gets.chomp.downcase
  end
end
