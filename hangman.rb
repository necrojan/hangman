# frozen_string_literal: true

require './player'
require './file_manager'

class Hangman
  attr_accessor :guess_letter,
                :word, :tries, :player, :file_manager, :status, :complete

  def initialize(player)
    @word = random_word
    @guess_letter = []
    @tries = 0
    @player = player
    @file_manager = FileManager.new
    @complete = false
  end

  def play
    player_name = @player.player_name
    load_file(player_name)

    while @tries < 5
      display_incorrect_tries
      letter = store_and_get_letter

      display_guesses

      @tries += 1 unless @word.include?(letter)

      save(player_name)

      guess_word = modify_word

      puts guess_word

      if check_if_game_over
        @complete = true
        save(player_name)
      end

      next if guess_word.include?('_')

      @complete = true
      save(player_name)
      puts 'You win!'
      break
    end
  end

  private

  def load_file(player_name)
    return unless @file_manager.yes_or_no?('open')

    begin
      previous_obj = load_obj(player_name)[0]
    rescue Errno::ENOENT => e
      puts e.message.slice(0..(e.message.index('y')))
      sleep(2)
      puts 'Starting a new game...'
    else
      abort 'Game already completed!' if previous_obj.complete == true
      @word = previous_obj.word
      @guess_letter = previous_obj.guess_letter
      @tries = previous_obj.tries
      @player = previous_obj.player
    end
  end

  def random_word
    words = File.readlines '5desk.txt'

    loop do
      @word = words[rand(words.length)].downcase.strip
      return @word if (@word.length >= 5) && (@word.length <= 12)
    end
  end

  def load_obj(player_name)
    @file_manager.load(player_name)
  end

  def store_and_get_letter
    letter = @player.guess_letter
    puts 'Checking..'
    sleep(2)
    @guess_letter << letter
    letter
  end

  def modify_word
    @word.chars.map { |char| @guess_letter.include?(char) ? char : '_' }.join(' ')
  end

  def check_if_game_over
    if @tries == 5
      puts 'Game Over!'
      puts "You have reached #{@tries} tries!"
      puts "The guess word is #{@word}"
      true
    end
  end

  def display_incorrect_tries
    puts "You have #{@tries} incorrect guess"
  end

  def display_guesses
    puts 'Your guessed word'
    p guess_letter
  end

  def save(player_name)
    @file_manager.save(player_name, self)
  end
end

h = Hangman.new(Player.new)
h.play
