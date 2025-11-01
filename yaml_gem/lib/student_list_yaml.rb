require 'yaml'
require_relative 'student_list_base.rb'

class StudentsListYAML < StudentsListBase
  def initialize(filename = "students.yaml")
    super(filename)
  end
  
  def read_all
    begin
      create_file_if_not_exists
      
      if file_empty?
        puts "Файл #{@filename} пустой"
        @students_table = DataTable.new([])
        return []
      end
      
      data = parse_file_content || []
      table_data = prepare_data_for_table(data)
      @students_table = DataTable.new(table_data)
      
      puts "Успешно прочитано #{@students_table.rows_count} записей из файла #{@filename}"
      data
      
    rescue syntax_error_class => e
      puts "Ошибка чтения YAML: #{e}. Создаем новый файл."
      File.open(@filename, 'w:utf-8') do |file|
        file.write(initial_file_content)
      end
      @students_table = DataTable.new([])
      return []
    rescue => e
      puts "Ошибка при чтении файла: #{e}"
      @students_table = DataTable.new([])
      return []
    end
  end
  
  def write_all(data_table = nil)
    begin
      data_to_write = data_table || @students_table
      create_file_if_not_exists
      
      data_hash = prepare_data_for_write(data_to_write)
      serialized_data = serialize_data(data_hash)
      
      File.open(@filename, 'w:utf-8') do |file|
        file.write(serialized_data)
      end
      
      @students_table = data_to_write
      puts "Успешно записано #{data_to_write.rows_count} записей в файл #{@filename}"
      true
      
    rescue => e
      puts "Ошибка при записи в файл: #{e}"
      false
    end
  end
  
  private
  
  def initial_file_content
    [].to_yaml
  end
  
  def parse_file_content
    YAML.load_file(@filename)
  end
  
  def serialize_data(data_hash)
    data_hash.to_yaml
  end
  
  def file_empty?
    File.zero?(@filename)
  end
  
  def syntax_error_class
    Psych::SyntaxError
  end
end