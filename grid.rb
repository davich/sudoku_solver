class Grid
  def initialize(data)
    @data = data
  end
  def populate_empty_cells_with_array
    @data.each do |line| 
      line.each_with_index do |square, i| 
        line[i] = (1..9).to_a if square == 0
      end
    end
  end
  def complete?
    @data.all? { |line| line.all? { |square| square.is_a?(Fixnum) && square > 0 && square < 10 } }
  end
  def p_grid
    puts "GRID IS: "
    @data.each { |row| puts row.join("\t") }
  end
  def duplicate
    dup_grid = []
    @data.each { |row| dup_grid << row.dup}
    Grid.new(dup_grid)
  end
  def find_first_unknown_cell
    j = nil
    i = @data.index { |row| j = row.index { |square| square.is_a?(Array) }}
    return [i, j]
  end
  def square_nums(i, j)
    i = i/3
    j = j/3
    nums = []
    for k in i*3..i*3+2
      for l in j*3..j*3+2
        if @data[k][l].is_a?(Fixnum)
          nums << @data[k][l]
        end
      end
    end
    nums
  end
  
  def collect_adjacent_numbers(i, j)
    col = @data.collect { |row| row[j] if row[j].is_a?(Fixnum) }.compact
    row = @data[i].select { |square| square.is_a?(Fixnum) }.compact
    square = square_nums(i, j)
    (col + row + square)
  end

  def [](i)
    @data[i]
  end
  def data
    @data
  end
end
