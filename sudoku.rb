require 'pp'
class Sudoku
  class << self
    def solve(grid)
      populate_empty_cells_with_array(grid)
      calc_sudoku grid
    end

    def populate_empty_cells_with_array(grid)
      grid.each do |line| 
        line.each_with_index do |square, i| 
          line[i] = (1..9).to_a if square == 0
        end
      end
    end

    def calc_sudoku(grid)
      begin
        grid_changed = false
        for_each_cell do |i, j|
          if grid[i][j].is_a?(Array)
            cross_over = grid[i][j] & collect_adjacent_numbers(grid, i, j)
            grid_changed ||= !cross_over.empty?
            grid[i][j] = grid[i][j].reject { |item| cross_over.include? item }

            if grid[i][j].size == 1
              grid[i][j] = grid[i][j][0]
            end
            return nil if grid[i][j].size == 0
          end
        end
      end while grid_changed

      unless complete?(grid)
        grid = take_a_guess(grid)
      end
  
      grid && complete?(grid) ? grid : nil
    end

    def collect_adjacent_numbers(grid, i, j)
      col = grid.collect { |row| row[j] if row[j].is_a?(Fixnum) }.compact
      row = grid[i].select { |square| square.is_a?(Fixnum) }.compact
      square = square_nums(grid, i, j)
      (col + row + square)
    end

    def for_each_cell
      for i in 0..8
        for j in 0..8
          yield i, j
        end
      end
    end

    def take_a_guess(grid)
      j = nil
      i = grid.index { |row| j = row.index { |square| square.is_a?(Array) }}
      result = nil
      grid[i][j].find do |val|
        dup_grid = []
        grid.each { |row| dup_grid << row.dup}
        dup_grid[i][j] = val
        result = calc_sudoku(dup_grid)
      end
      result
    end

    def square_nums grid, i, j
      i = i/3
      j = j/3
      nums = []
      for k in i*3..i*3+2
        for l in j*3..j*3+2
          if grid[k][l].is_a?(Fixnum)
            nums << grid[k][l]
          end
        end
      end
      nums
    end

    def complete?(grid)
      grid.all? { |line| line.all? { |square| square.is_a?(Fixnum) && square > 0 && square < 10 } }
    end
 
    def p_grid(grid)
      puts "GRID IS: "
      grid.each { |row| puts row.join("\t") }
    end
  end
end

pp Sudoku.solve([
[4,0,0,0,2,7,0,0,0],
[0,0,0,0,0,0,0,0,0],
[8,6,0,9,0,4,1,0,0],
[0,0,9,7,8,0,0,0,0],
[6,2,0,0,0,0,0,8,7],
[0,0,0,0,1,2,3,0,0],
[0,0,5,3,0,8,0,1,2],
[0,0,0,0,0,0,0,0,0],
[0,0,0,5,6,0,0,0,3]])

pp Sudoku.solve([
[8,0,0,0,0,0,0,0,0],
[0,0,3,6,0,0,0,0,0],
[0,7,0,0,9,0,2,0,0],
[0,5,0,0,0,7,0,0,0],
[0,0,0,0,4,5,7,0,0],
[0,0,0,1,0,0,0,3,0],
[0,0,1,0,0,0,0,6,8],
[0,0,8,5,0,0,0,1,0],
[0,9,0,0,0,0,4,0,0]])

pp Sudoku.solve([
[1,0,0,0,0,7,0,9,0],
[0,3,0,0,2,0,0,0,8],
[0,0,9,6,0,0,5,0,0],
[0,0,5,3,0,0,9,0,0],
[0,1,0,0,8,0,0,0,2],
[6,0,0,0,0,4,0,0,0],
[3,0,0,0,0,0,0,1,0],
[0,4,0,0,0,0,0,0,7],
[0,0,7,0,0,0,3,0,0]])
