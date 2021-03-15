# frozen_string_literal: true

require 'yaml'

class FileManager
  def save(player_name, class_file)
    if class_file.complete == false
      return unless yes_or_no?('save'.capitalize)
    end

    File.open("#{player_name}.yml", 'w') do |file|
      YAML.dump([] << class_file, file)
    end
  end

  def load(file_name)
    YAML.load_file("./#{file_name}.yml")
  end

  def yes_or_no?(text)
    puts "#{text} game? y for yes n for no"
    answer = gets.chomp.downcase
    return false if answer == 'n'

    true
  end
end
