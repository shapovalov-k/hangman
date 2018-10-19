# encoding: utf-8
#
# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
#
class Game
  attr_reader :errors, :letters, :good_letters, :bad_letters, :status

  attr_accessor :version

  # Константа с максимальным количеством ошибок
  MAX_ERRORS = 7

  def initialize(word)
    @letters = get_letters(word)
    @errors = 0
    @good_letters = []
    @bad_letters = []

    # Специальная переменная-индикатор состояния игры
    @status = :in_progress # :won, :lost
  end

  def get_letters(word)
    if word.nil? || word == ""
      abort "Загадано пустое слово, нечего отгадывать. Закрываемся"
    else
      word = word.encode('UTF-8')
    end

    word.split('')
  end

  def max_errors
    MAX_ERRORS
  end

  def errors_left
    MAX_ERRORS - @errors
  end

  def is_good?(letter)
    @letters.include?(letter) ||
        (letter == "е" && @letters.include?("ё")) ||
        (letter == "ё" && @letters.include?("е")) ||
        (letter == "и" && @letters.include?("й")) ||
        (letter == "й" && @letters.include?("и"))
  end

  def add_letter_to(letters, letter)
    # Если в слове есть буква запишем её в число "правильных" буква
    letters << letter

    case letter
    when "е" then letters << "ё"
    when "ё" then letters << "е"
    when "и" then letters << "й"
    when "й" then letters << "и"
    end
  end

  def solved?
    (@letters - @good_letters).empty?
  end

  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  def lost?
    @status == :lost || @errors >= MAX_ERRORS
  end

  def in_progress?
    @status == :in_progress
  end

  def won?
    @status == :won
  end

  # Основной метод игры "сделать следующий шаг". В качестве параметра принимает
  # букву, которую ввел пользователь.
  def next_step(letter)
    return if @status == :lost || @status == :won

    return if repeated?(letter)

    if is_good?(letter)
      add_letter_to(@good_letters, letter)

      @status = :won if solved?

    else
      add_letter_to(@bad_letters, letter)

      @errors += 1

      @status = :lost if lost?
    end
  end

  def ask_next_letter
    puts "\nВведите следующую букву"

    letter = ""

    while letter == ""
      letter = STDIN.gets.encode("UTF-8").chomp
      letter = Unicode::downcase(letter)
    end

    next_step(letter)
  end
end
