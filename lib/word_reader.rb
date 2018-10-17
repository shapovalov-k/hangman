# encoding: utf-8
#
# Класс WordReader, отвечающий за чтение слова для игры.
class WordReader
  # Так как, подобно классу ResultPrinter, экземляр этого класса не хранит
  # в себе никаких данных, конструктор отсутствует.

  # Сохраним старую возможность читать слово из аргументов командной строки. В
  # качестве отедльного метода read_from_args для обратной совместимости.
  def read_from_args
    word = ARGV[0]

    if word == nil || word == ""
      return
    else
      return Unicode.downcase(word)
    end
  end

  # Метод read_from_file, возвращающий случайное слово, прочитанное из файла,
  # имя которого нужно передать методу в качестве единственного аргумента.
  def read_from_file(file_name)
    begin
      # Открываем файл, явно указывая его кодировку, читаем все строки в массив и
      # закрываем файл.
      file = File.new(file_name, "r:UTF-8")
      lines = file.readlines
      file.close

    rescue SystemCallError
      abort "Файл не найден."
    end

    # Возвращаем случайную строчку (слово) из прочитанного массива.
    return Unicode.downcase(lines.sample.chomp)
  end
end
