class DataList
    include Enumerable
    def initialize(elements)
        @elements = elements
        @selected = []
    end

    def elements=(new_elements)
        @elements = new_elements.dup
        clear_selected
    end

    def select(number)
        validate_index(number)
        @selected << number unless @selected.include?(number)
    end

    def get_selected
        @selected.map { |index| @elements[index].id }.dup
    end

    def get_names
        name = "№ по порядку"
    end

    def get_data
        data = []
        
        @elements.each_with_index do |element, index|
            row = [index + 1]
            row.concat(element_info(element))
            data << row
        end
        
        create_data_table(data)
        
    end

    def element_info student
        raise NotImplementedError, "Метод #{__method__} должен быть реализован в наследниках"
    end

    def create_data_table data
        raise NotImplementedError, "Метод #{__method__} должен быть реализован в наследниках"
    end

    def clear_selected
        @selected.clear
    end
    def each(&block)
        @elements.each(&block)
    end

     def data
        @elements.dup
    end

    def each_row
        return enum_for(:each_row) unless block_given?
        
        data_table = get_data
        (0...data_table.rows_count).each do |row_index|
            row = (0...data_table.cols_count).map { |col_index| data_table.get_element(row_index, col_index) }
            yield(row, row_index)
        end
    end

    protected

    def validate_index(index)
        if index < 0 || index >= @elements.length
            raise IndexError, "Некорректный индекс: #{index}"
        end
    end

end