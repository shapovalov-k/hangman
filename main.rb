# encoding: utf-8
#
# Hangman is a classic paper and pencil guessing game in which you must guess the word before you hang.
#
# https://en.wikipedia.org/wiki/Hangman_(game)
# https://ru.wikipedia.org/wiki/Виселица_(игра)
#
# This block of code is necessary only when using cyrillic letters on Windows.
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

VERSION = " Game 'Hangman', version 0.1. (c) shapovalov-k"

current_path = "./" + File.dirname(__FILE__)

require "unicode"
require current_path + "/lib/game.rb"
require current_path + "/lib/result_printer.rb"
require current_path + "/lib/word_reader.rb"

word_reader = WordReader.new

# Соберем путь к файлу со словами из пути к файлу, где лежит программа и
# относительно пути к файлу words.txt.
words_file_name = current_path + "/data/words.txt"

# Создаем объект класса Game, вызывая конструктор и передавая ему слово, которое
# вернет метод read_from_file экземпляра класса WordReader.

if word_reader.read_from_args != nil
  game = Game.new(word_reader.read_from_args)
else
  game = Game.new(word_reader.read_from_file(words_file_name))
end

game.version = VERSION
printer = ResultPrinter.new(game)

while game.in_progress? do
  printer.print_status(game)
  game.ask_next_letter
end

printer.print_status(game)
