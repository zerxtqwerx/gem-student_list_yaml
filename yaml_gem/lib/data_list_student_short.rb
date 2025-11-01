require_relative 'data_list'
require_relative 'student_short'
require_relative 'data_table'

class DataListStudentShort < DataList
    def get_names
        name = super
        [name, "ФИО", "Контакт", "Git"]
    end

    def element_info(student)
      [student.last_name_initials, student.contact || "нет", student.git || "нет"]
    end

    def create_data_table(data)
      DataTable.new(data)
    end
end












  
  puts "\n1. Тест с объектами StudentShort:"
  student1 = StudentShort.new(id: 1, initials: "Иванов И.И.", contact: "@ivanov", git: "github.com/ivanov")
  student2 = StudentShort.new(id: 2, initials: "Петров П.П.", contact: "petrov@mail.com", git: "github.com/petrov")
  student3 = StudentShort.new(id: 3, initials: "Сидоров С.С.", contact: nil, git: "github.com/sidorov")
  
  students = [student1, student2, student3]
  list1 = DataListStudentShort.new(students)

  names = list1.get_names
  expected_names = ["№ по порядку", "ФИО", "Контакт", "Git"]
  if names == expected_names
    puts "get_names корректно: #{names.inspect}"
  else
    puts "get_names ошибка: #{names.inspect}, ожидалось: #{expected_names.inspect}"
  end
  

  element_info = list1.element_info(student1)
  expected_info = ["Иванов И.И.", "@ivanov", "github.com/ivanov"]
  if element_info == expected_info
    puts "element_info корректно: #{element_info.inspect}"
  else
    puts "element_info ошибка: #{element_info.inspect}, ожидалось: #{expected_info.inspect}"
  end

  test_data = [[1, "Тест", "контакт", "git"]]
  table1 = list1.create_data_table(test_data)
  if table1.is_a?(DataTable)
    puts "create_data_table возвращает DataTable"
  else
    puts "create_data_table не возвращает DataTable"
  end

  if list1.get_selected.empty?
    puts "Выделение сброшено при замене данных"
  else
    puts "Выделение не сброшено"
  end

  
