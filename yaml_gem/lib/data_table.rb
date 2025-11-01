class DataTable
  def initialize(data)
    @data = validate_data(data)
  end

  def get_element(row, col)
    validate_indices(row, col)
    @data[row][col]
  end

  def rows_count
    @data.size
  end

  def cols_count
    return 0 if @data.empty?
    @data[0].size
  end

  def each(&block)
    return enum_for(:each) unless block_given?
    
    (0...rows_count).each do |row|
      (0...cols_count).each do |col|
        yield(@data[row][col], row, col)
      end
    end
  end

  def each_row(&block)
    return enum_for(:each_row) unless block_given?
    
    (0...rows_count).each do |row|
      yield(@data[row], row)
    end
  end

  def each_column(&block)
    return enum_for(:each_column) unless block_given?
    
    (0...cols_count).each do |col|
      column_data = (0...rows_count).map { |row| @data[row][col] }
      yield(column_data, col)
    end
  end

 
  def each_with_index(&block)
    return enum_for(:each_with_index) unless block_given?
    
    (0...rows_count).each do |row|
      (0...cols_count).each do |col|
        yield(@data[row][col], row, col)
      end
    end
  end

  def row(index)
    validate_indices(index, 0) 
    @data[index].dup
  end

  def column(index)
    raise ArgumentError, "Индекс столбца вышел за границу: #{index}" if index < 0 || index >= cols_count
    (0...rows_count).map { |row| @data[row][index] }
  end

  def to_a
    @data.map(&:dup)
  end

  private

  def validate_data(data)
    raise ArgumentError, "Должен быть 2-мерным массивом." unless data.is_a?(Array) && data.all? { |row| row.is_a?(Array) }

    unless data.empty?
      first_row_size = data[0].size
      data.each_with_index do |row, index|
        raise ArgumentError, "Все строки должны содержать одинаковое количество столбцов. Строка #{index} имеет #{row.size}, ожидалось #{first_row_size}" unless row.size == first_row_size
      end
    end
    
    data
  end

  def validate_indices(row, col)
    raise ArgumentError, "Индекс строки вышел за границу: #{row}" if row < 0 || row >= rows_count
    raise ArgumentError, "Индекс столбца вышел за границу: #{col}" if col < 0 || col >= cols_count
  end
end