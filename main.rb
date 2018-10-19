# encoding: utf-8
#
# Hangman is a classic paper and pencil guessing game in which you must guess the word before you hang.
#
# https://en.wikipedia.org/wiki/Hangman_(game)
#
# This block of code is necessary only when using cyrillic letters on Windows.

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

VERSION = "Game 'Hangman', version 0.5. (c) shapovalov-k"

require "unicode"

require_relative 'lib/game'
require_relative 'lib/result_printer'
require_relative 'lib/word_reader'

word_reader = WordReader.new

words_file_name = "#{File.dirname(__FILE__)}/data/words.txt"

if word_reader.read_from_args != nil
  game = Game.new(word_reader.read_from_args)
else
  game = Game.new(word_reader.read_from_file(words_file_name))
end

game.version = VERSION

printer = ResultPrinter.new(game)

while game.in_progress?
  printer.print_status(game)
  game.ask_next_letter
end

printer.print_status(game)
