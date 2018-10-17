# encoding: utf-8
#
# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
#
# За основу взяты методы из первой версии этой игры (подробные комментарии
# смотрите в прошлых уроках).
class Game
  attr_reader :errors, :letters, :good_letters, :bad_letters, :status
  attr_accessor :version

  MAX_ERRORS = 7

  # Конструктор — вызывается всегда при создании объекта данного класса имеет
  # один параметр, в него нужно передавать при создании строку к загаданнмы
  # словом. Например, game = Game.new('молоко').
  def initialize(word)
    # Инициализируем переменные экземпляра. В @letters будет лежать массив букв
    # загаданного слова. Для того, чтобы его создать, вызываем метод get_letters
    # этого же класса.
    @letters = get_letters(word)

    # Переменная @errors будет хранить текущее количество ошибок, всего можно
    # сделать не более 7 ошибок. Начальное значение — 0.
    @errors = 0

    # Переменные @good_letters и @bad_lettes будут содержать массивы, хранящие
    # угаданные и неугаданные буквы. В начале игры они пустые.
    @good_letters = []
    @bad_letters = []

    # Специальная переменная-индикатор состояния игры (см. метод get_status)
    @status = :in_progress # :won, :lost
  end

  # Метод, который возвращает массив букв загаданного слова
  def get_letters(word)
    if word == nil || word == ""
      abort "Загадано пустое слово, нечего отгадывать. Закрываемся"
    end

    word.encode('UTF-8').split("")
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
    @status = :won
  end

  # Основной метод игры "сделать следующий шаг". В качестве параметра принимает
  # букву, которую ввел пользователь.
  def next_step(letter)
    # Предварительная проверка: если статус игры равен 1 или -1, значит игра
    # закончена и нет смысла дальше делать шаг. Выходим из метода возвращая
    # пустое значение.
    return if @status == :lost || @status == :won

    # Если введенная буква уже есть в списке "правильных" или "ошибочных" букв,
    # то ничего не изменилось, выходим из метода.
    return if repeated?(letter)

    if is_good?(letter)
      add_letter_to(@good_letters, letter)
      # Дополнительная проверка — угадано ли на этой букве все слово целиком.
      # Если да — меняем значение переменной @status на 1 — победа.
      @status = :won if solved?

    else
      # Если в слове нет введенной буквы — добавляем эту букву в массив
      # «плохих» букв и увеличиваем счетчик ошибок.
      add_letter_to(@bad_letters, letter)

      @errors += 1

      # Если ошибок больше 7 — статус игры меняем на -1, проигрыш.
      @status = :lost if lost?
    end
  end

  # Метод, спрашивающий юзера букву и возвращающий ее как результат. В идеале
  # этот метод лучше вынести в другой класс, потому что он относится не только
  # к состоянию игры, но и к вводу данных.
  def ask_next_letter
    puts "\nВведите следующую букву"

    letter = ""
    while letter == ""
      letter = STDIN.gets.encode("UTF-8").chomp
      letter = Unicode::downcase(letter)
    end

    # После получения ввода, передаем управление в основной метод игры
    next_step(letter)
  end

  # Методы, так называемые accessors или геттеры. Смысл каждого метода — только
  # предоставить доступ к внутренним переменным экземпляра класса. Без таких
  # методов, например к @letters, @errors нет доступа ни у кого, кроме самого
  # объекта данного класса
  def errors
    # Важная фишка Ruby: слово return можно опустить, если это последняя строка
    # в методе. Последнее вычисленное значение в методе и будет возвращено.
    @errors
  end
end
