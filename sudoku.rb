require 'pp'
class Sudoku
  class << self
    def sudoku(grid)
      anything = [1,2,3,4,5,6,7,8,9]
      grid.each { |line| line.each_with_index { |square, i| line[i] = anything.dup if square == 0 }}
      calc_sudoku grid
    end

    def calc_sudoku(grid)
      begin
        grid_changed = false
        for i in 0..8
          for j in 0..8
            if grid[i][j].is_a?(Array)
              col = grid.collect { |row| row[j] if row[j].is_a?(Fixnum) }.compact
              row = grid[i].select { |square| square.is_a?(Fixnum) }.compact
              square = square_nums(grid, i, j)
        
              cross_over = grid[i][j] & (col+row+square)
              grid_changed ||= !cross_over.empty?
              grid[i][j] = grid[i][j].reject { |item| cross_over.include? item }
              grid[i][j] = grid[i][j][0] if grid[i][j].size == 1
              return nil if grid[i][j].size == 0
            end
          end
        end
      end while grid_changed

      unless complete?(grid)
        grid = take_a_guess(grid)
      end
  
      grid && complete?(grid) ? grid : nil
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

pp Sudoku.sudoku([
[4,0,0,0,2,7,0,0,0],
[0,0,0,0,0,0,0,0,0],
[8,6,0,9,0,4,1,0,0],
[0,0,9,7,8,0,0,0,0],
[6,2,0,0,0,0,0,8,7],
[0,0,0,0,1,2,3,0,0],
[0,0,5,3,0,8,0,1,2],
[0,0,0,0,0,0,0,0,0],
[0,0,0,5,6,0,0,0,3]])

pp Sudoku.sudoku([
[8,0,0,0,0,0,0,0,0],
[0,0,3,6,0,0,0,0,0],
[0,7,0,0,9,0,2,0,0],
[0,5,0,0,0,7,0,0,0],
[0,0,0,0,4,5,7,0,0],
[0,0,0,1,0,0,0,3,0],
[0,0,1,0,0,0,0,6,8],
[0,0,8,5,0,0,0,1,0],
[0,9,0,0,0,0,4,0,0]])

pp Sudoku.sudoku([
[1,0,0,0,0,7,0,9,0],
[0,3,0,0,2,0,0,0,8],
[0,0,9,6,0,0,5,0,0],
[0,0,5,3,0,0,9,0,0],
[0,1,0,0,8,0,0,0,2],
[6,0,0,0,0,4,0,0,0],
[3,0,0,0,0,0,0,1,0],
[0,4,0,0,0,0,0,0,7],
[0,0,7,0,0,0,3,0,0]])
