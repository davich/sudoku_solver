require 'spec_helper'
describe Grid do
  before(:each) do
    @incomplete_grid = Grid.new([
      [4,5,[1,2],1,2,7,1,1,1],
      [[2,2],[1,3],7,1,2,7,1,1,1],
      [[6,7],8,9,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1]])
    @complete_grid = Grid.new([
      [4,5,1,1,2,7,1,1,1],
      [4,1,5,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1],
      [4,1,1,1,2,7,1,1,1]])
  end
  it "should populate empty cells with anything array" do
    grid = Grid.new([
    [4,0,1,1,2,7,1,1,1],
    [4,1,0,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1]])
    grid.populate_empty_cells_with_array
    grid.data.should == [
    [4,[1,2,3,4,5,6,7,8,9],1,1,2,7,1,1,1],
    [4,1,[1,2,3,4,5,6,7,8,9],1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1],
    [4,1,1,1,2,7,1,1,1]]
  end
  describe "complete?" do
    it "should check if grid is complete" do
      @complete_grid.complete?.should == true
    end
    it "should return false if grid is not complete" do
      @incomplete_grid.complete?.should == false
    end
  end
  it "should duplicate grid with duplicate data" do
    grid2 = @incomplete_grid.duplicate
    @incomplete_grid.data.should == grid2.data
    grid2[0][0] = 9
    @incomplete_grid.data.should_not == grid2.data
  end
  it "should find first unknown cell" do
    @incomplete_grid.find_first_unknown_cell.should == [0,2]
  end
  it "should find known numbers in the 9 squares box" do
    @incomplete_grid.square_nums(2,0).should == [4,5,7,8,9]
  end
  it "should collect all known numbers in row, column and 9square box" do
    @incomplete_grid.collect_adjacent_numbers(7,1).uniq.sort.should == [1,2,4,5,7,8]
  end
end