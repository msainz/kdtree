
require 'rspec'
require './kdtree.rb'

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
      @kdtree.root.axis.should eql 0
      @kdtree.root.left_child.location.should eql [5,4]
      @kdtree.root.left_child.axis.should eql 1
      @kdtree.root.left_child.left_child.location.should eql [2,3]
      @kdtree.root.left_child.left_child.axis.should eql 0      
      @kdtree.root.left_child.left_child.left_child.should be_nil
      @kdtree.root.left_child.left_child.right_child.should be_nil
      @kdtree.root.left_child.right_child.location.should eql [4,7]
      @kdtree.root.left_child.right_child.axis.should eql 0
      @kdtree.root.left_child.right_child.left_child.should be_nil
      @kdtree.root.left_child.right_child.right_child.should be_nil
      @kdtree.root.right_child.location.should eql [9,6]
      @kdtree.root.right_child.axis.should eql 1
      @kdtree.root.right_child.left_child.location.should eql [8,1]
      @kdtree.root.right_child.left_child.axis.should eql 0      
      @kdtree.root.right_child.left_child.left_child.should be_nil
      @kdtree.root.right_child.left_child.right_child.should be_nil
      @kdtree.root.right_child.right_child.should be_nil
    end
  end
  describe '#nearest_neighbors' do
    it 'correctly finds the nearest neighbor' do
      candidates = [[0,0], [7,2], [(4+9)/2.0,(6+7)/2.0]] # the last candidate is midway between 2 nearest neighbors
      candidates.map {|c| @kdtree.nearest_neighbors(c).location }.should eql [[2,3], [7,2], [9,6]]
    end
  end
  context 'private methods' do
    describe '#distance' do
      it 'computes squared euclidean distance in 2 or more dimensions' do
        @kdtree.send(:distance, [1,2], [3,4]).should eql 8
        @kdtree.send(:distance, [1,2,3], [4,5,6]).should eql 27
      end
    end
    describe '#distance_to_hyperplane' do
      it 'computes squared euclidean distance along the specified dimension' do
        @kdtree.send(:distance_to_hyperplane, [1,2], [3,4], 0).should eql 4
        @kdtree.send(:distance_to_hyperplane, [1,2,3], [4,5,6], 1).should eql 9
      end
    end  
    describe '#nearer_or_farther_child' do
      before do
        @node = Node.new([], 0, 
          Node.new([0,2],-1),
          Node.new([1,0],-1))
      end
      it 'correctly returns the nearer child' do
        @kdtree.send(:nearer_child, @node, [0.5,1.8]).should eql @node.left_child
      end
      it 'correctly returns the farther child' do
        @kdtree.send(:farther_child, @node, [0.5,1.8]).should eql @node.right_child
      end
    end
  end
  describe '#to_yaml' do
  end
end