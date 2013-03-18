
require 'rspec'
require './src/kdtree'

describe KDTree do
  before do
    @points_in_2D = [[2,3], [5,4], [9,6], [4,7], [8,1], [7,2]]
    @kdtree = KDTree.new @points_in_2D
  end
  describe '#initialize' do
    it 'correctly builds a 2D-tree' do
      @kdtree.k.should eql 2
      # depth-first assertions
      @kdtree.root.location.should eql [7,2]
      @kdtree.root.split.should eql 0
      @kdtree.root.left.location.should eql [5,4]
      @kdtree.root.left.split.should eql 1
      @kdtree.root.left.left.location.should eql [2,3]
      @kdtree.root.left.left.split.should eql 0      
      @kdtree.root.left.left.left.should be_nil
      @kdtree.root.left.left.right.should be_nil
      @kdtree.root.left.right.location.should eql [4,7]
      @kdtree.root.left.right.split.should eql 0
      @kdtree.root.left.right.left.should be_nil
      @kdtree.root.left.right.right.should be_nil
      @kdtree.root.right.location.should eql [9,6]
      @kdtree.root.right.split.should eql 1
      @kdtree.root.right.left.location.should eql [8,1]
      @kdtree.root.right.left.split.should eql 0      
      @kdtree.root.right.left.left.should be_nil
      @kdtree.root.right.left.right.should be_nil
      @kdtree.root.right.right.should be_nil
    end
  end
  describe '#to_a' do
    it 'correctly returns the tree in (inorder) array form' do
      @kdtree.to_a.should eql [[2, 3], [5, 4], [4, 7], [7, 2], [8, 1], [9, 6]]
    end
  end
  describe '#nnearest' do
    before do
      @neighbors = [[6, 33], [9, 37], [12, 10], [15, 14], [20, 31], [22, 1], [25, 96], [31, 41], [31, 65], [36, 30], 
                   [46, 36], [56, 51], [57, 80], [62, 55], [78, 12], [81, 97], [86, 79], [91, 3]]
    end
    it 'correctly finds the nearest neighbor' do
      newcomers = [[0,0], [7,2], [(4+9)/2.0,(6+7)/2.0]] # the last newcomer is midway between 2 nearest neighbors
      newcomers.map {|newcomer| @kdtree.nnearest(newcomer) }.should eql [ [[2,3]], [[7,2]], [[4,7]] ]
      
      kdtree = KDTree.new @neighbors
      puts ''; kdtree.print; puts ''
      kdtree.nnearest([10, 34]).should eql [[9, 37]]
    end
    it 'correctly finds more than one nearest neighbors' do
      kdtree = KDTree.new @neighbors
      kdtree.nnearest([10, 34], 3).should eql [ [9, 37], [6, 33], [20, 31] ]
    end
  end
  context 'private methods' do
    describe '#distance' do
      it 'computes squared euclidean distance in 2 or more dimensions' do
        @kdtree.send(:distance, [1,2], [3,4]).should eql 8
        @kdtree.send(:distance, [1,2,3], [4,5,6]).should eql 27
      end
    end
  end
end
