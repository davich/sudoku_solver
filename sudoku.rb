require 'pp'
class Sudoku
  class << self
    def solve(grid_data)
      grid = Grid.new(grid_data)
      grid.populate_empty_cells_with_array
      result = calc_sudoku(grid)
      result.nil? ? nil : result.data
    end
  end
private
  class ImpossibleToSolveException < RuntimeError
  end
  class << self
    def calc_sudoku(grid)
      begin
        grid_changed = eliminate_numbers(grid)
      rescue ImpossibleToSolveException
        return nil
      end while grid_changed

      unless grid.complete?
        grid = take_a_guess(grid)
      end
  
      grid && grid.complete? ? grid : nil
    end

    def eliminate_numbers(grid)
      grid_changed = false
      for_each_cell do |i, j|
        next unless grid[i][j].is_a?(Array)
        cross_over = grid[i][j] & grid.collect_adjacent_numbers(i, j)
        grid_changed ||= !cross_over.empty?
        grid[i][j] = grid[i][j].reject { |item| cross_over.include? item }

          
        grid[i][j] = grid[i][j][0] if grid[i][j].size == 1
        raise ImpossibleToSolveException.new if grid[i][j].size == 0
      end
      grid_changed
    end

    def for_each_cell
      for i in 0..8
        for j in 0..8
          yield i, j
        end
      end
    end

    def take_a_guess(grid)
      i, j = grid.find_first_unknown_cell
      result = nil
      grid[i][j].find do |val|
        dup_grid = grid.duplicate
        dup_grid[i][j] = val
        result = calc_sudoku(dup_grid)
      end
      result
    end
  end
end


