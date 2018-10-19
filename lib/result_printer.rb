# encoding: utf-8
#
# Класс ResultPrinter, печатающий состояние и результаты игры.
class ResultPrinter
  def initialize(game)
    @status_image = []

    current_path = File.dirname(__FILE__)

    counter = 0

   while counter <= game.max_errors do
      # Соберем путь к файлу с изображением виселицы. Каждыый из них лежит в
      # папке /image/ и называется 0.txt, 1.txt, 2.txt и т. д.
      file_name = current_path + "/../image/#{counter}.txt"

      begin
        file = File.new(file_name, "r:UTF-8")
        @status_image << file.read
        file.close
      rescue SystemCallError
        # Если файла нет, вместо соответствующей картинки будет «заглушка»
        @status_image << "\n [ изображение не найдено ] \n"
      end

      counter += 1
    end
  end

  def print_hangman(errors)
    puts @status_image[errors]
  end

  def print_status(game)
    cls
    puts game.version

    puts "\nСлово: #{get_word_for_print(game.letters, game.good_letters)}"
    puts "Ошибки: #{game.bad_letters.join(', ')}"

    print_hangman(game.errors)

    if game.lost?
      puts "\nВы проиграли :("
      puts "Загаданное слово было: " + game.letters.join('')
      puts
    elsif game.won?
      puts "Поздравляем, вы выиграли!\n\n"
    else
      puts "У вас осталось ошибок: #{game.errors_left}"
    end
  end

  def get_word_for_print(letters, good_letters)
    result = ""

    for item in letters do
      if good_letters.include?(item)
        result += item + " "
      else
        result += "__ "
      end
    end

    result
  end

  def cls
    system("clear") || system("cls")
  end
end
