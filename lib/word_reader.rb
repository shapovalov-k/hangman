# encoding: utf-8
#
# Класс WordReader, отвечающий за чтение слова для игры.
class WordReader
  def read_from_args
    word = ARGV[0]

    if word == nil || word == ""
      return
    else
      Unicode.downcase(word)
    end
  end

  def read_from_file(file_name)
    begin
      lines = File.readlines(file_name, encoding: 'UTF-8')

    rescue SystemCallError
      abort "Файл не найден."
    end

    # Возвращаем случайную строчку (слово) из прочитанного массива.
    Unicode.downcase(lines.sample.chomp)
  end
end
