require 'fileutils'
require_relative 'student.rb'
require_relative 'student_short.rb'
require_relative 'data_list_student_short.rb'
require_relative 'data_table'

class StudentsListBase
  attr_reader :students_table
  
  def initialize(filename)
    @filename = filename
    @students_table = DataTable.new([])
  end
 
  def read_all
    raise NotImplementedError, "Метод read_all должен быть реализован в подклассе"
  end
  
  def write_all(data_table = nil)
    raise NotImplementedError, "Метод write_all должен быть реализован в подклассе"
  end
  
  def get_student_by_id(student_id)
    @students_table.each_with_index do |element, row, col|
      if col == 0 && element == student_id
        return create_student_from_row(row)
      end
    end
    nil
  end

  def get_k_n_student_short_list(k, n, existing_data_list = nil)
    students_array = []

    @students_table.each_row do |row_data, row_index|
      student = create_student_from_row(row_index)
      students_array << student
    end

    sorted_students = students_array.sort_by { |student| student.last_name_initials }

    start_index = (k - 1) * n
    end_index = start_index + n
    
    students_slice = sorted_students[start_index...end_index] || []
    
    student_short_list = students_slice.map do |student|
      contact = student.phone || student.telegram || student.email
      
      StudentShort.new(
        id: student.id,
        initials: student.last_name_initials,
        contact: contact,
        git: student.git
      )
    end
    
    if existing_data_list
      existing_data_list.data = student_short_list
      existing_data_list
    else
      DataListStudentShort.new(student_short_list)
    end
  end
  
  def sort_by_last_name_initials
    students_array = []
    
    @students_table.each_row do |row_data, row_index|
      student = create_student_from_row(row_index)
      students_array << student
    end
    
    sorted_students = students_array.sort_by { |student| student.last_name_initials }

    table_data = sorted_students.map do |student|
      [
        student.id,
        student.last_name,
        student.first_name,
        student.patronymic,
        student.phone,
        student.telegram,
        student.email,
        student.git
      ]
    end
    
    @students_table = DataTable.new(table_data)
    write_all
    puts "Список отсортирован по Фамилия Инициалы"
  end
  
  def add_student(student)
    new_id = 1
    if @students_table.rows_count > 0
      max_id = 0
      @students_table.each do |element, row, col|
        if col == 0 && element > max_id
          max_id = element
        end
      end
      new_id = max_id + 1
    end
    
    student = Student.new(
      id: new_id, 
      last_name: student.last_name, 
      first_name: student.first_name, 
      patronymic: student.patronymic,
      git: student.git, 
      email: student.email, 
      phone: student.phone, 
      telegram: student.telegram
    )
    
    new_row = [
      student.id,
      student.last_name,
      student.first_name,
      student.patronymic,
      student.phone,
      student.telegram,
      student.email,
      student.git
    ]

    new_table_data = []
    @students_table.each_row do |row_data, row_index|
      new_table_data << row_data
    end
    new_table_data << new_row
    
    @students_table = DataTable.new(new_table_data)
    write_all
  end
  
  def update_student_by_id(student_id, updated_student)
    found = false
    new_table_data = []
    
    @students_table.each_row do |row_data, row_index|
      if row_data[0] == student_id
        new_table_data << [
          student_id,
          updated_student.last_name,
          updated_student.first_name,
          updated_student.patronymic,
          updated_student.phone,
          updated_student.telegram,
          updated_student.email,
          updated_student.git
        ]
        found = true
      else
        new_table_data << row_data
      end
    end
    
    if found
      @students_table = DataTable.new(new_table_data)
      write_all
    else
      puts "Студент с ID #{student_id} не найден"
      false
    end
  end
  
  def delete_student_by_id(student_id)
    initial_count = @students_table.rows_count
    new_table_data = []

    @students_table.each_row do |row_data, row_index|
      unless row_data[0] == student_id
        new_table_data << row_data
      end
    end
    
    if new_table_data.size < initial_count
      @students_table = DataTable.new(new_table_data)
      write_all
    else
      puts "Студент с ID #{student_id} не найден"
      false
    end
  end
  
  def get_student_short_count
    @students_table.rows_count
  end
  
  def get_all_students
    students = []
    @students_table.each_row do |row_data, row_index|
      students << create_student_from_row(row_index)
    end
    students
  end
  
  def clear_all
    @students_table = DataTable.new([])
    write_all
  end

  protected
  
  def create_file_if_not_exists
    dir = File.dirname(@filename)
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    unless File.exist?(@filename)
      File.open(@filename, 'w:utf-8') do |file|
        file.write(initial_file_content)
      end
      puts "Создан новый файл: #{@filename}"
    end
  end
  
  def create_student_from_row(row_index)
    row_data = @students_table.row(row_index)
    Student.new(
      last_name: row_data[1],
      first_name: row_data[2],
      patronymic: row_data[3],
      id: row_data[0],
      phone: row_data[4],
      telegram: row_data[5],
      email: row_data[6],
      git: row_data[7]
    )
  end
  
  def prepare_data_for_table(data)
    data.map do |item|
      [
        item['id'] || item[:id],
        item['last_name'] || item[:last_name] || "",
        item['first_name'] || item[:first_name] || "",
        item['patronymic'] || item[:patronymic] || "",
        item['phone'] || item[:phone] || "",
        item['telegram'] || item[:telegram] || "",
        item['email'] || item[:email] || "",
        item['git'] || item[:git] || ""
      ]
    end
  end
  
  def prepare_data_for_write(data_to_write)
    data_hash = []
    data_to_write.each_row do |row_data, row_index|
      data_hash << {
        'id' => row_data[0],
        'last_name' => row_data[1],
        'first_name' => row_data[2],
        'patronymic' => row_data[3],
        'phone' => row_data[4],
        'telegram' => row_data[5],
        'email' => row_data[6],
        'git' => row_data[7]
      }
    end
    data_hash
  end

  def initial_file_content
    raise NotImplementedError, "Метод initial_file_content должен быть реализован в подклассе"
  end
  
  def parse_file_content(file_content)
    raise NotImplementedError, "Метод parse_file_content должен быть реализован в подклассе"
  end
  
  def serialize_data(data_hash)
    raise NotImplementedError, "Метод serialize_data должен быть реализован в подклассе"
  end
  
  def file_empty?(file_content)
    raise NotImplementedError, "Метод file_empty? должен быть реализован в подклассе"
  end
  
  def syntax_error_class
    raise NotImplementedError, "Метод syntax_error_class должен быть реализован в подклассе"
  end
end