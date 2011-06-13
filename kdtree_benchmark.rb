
require './kdtree.rb'
require 'benchmark'

points = []
10000.times { |i| points << [rand, rand] }  
@@neighbors = points[0..4999]
@@newcomers = points[5000..-1]

def euclidean_distance m, n
  Math.sqrt( m.each_with_index.inject(0) { |tot, (coord, index)| tot += (coord - n[index]) ** 2 } )
end

LABELS = ['trivial 1NN search', 'kdtree 1NN search']
@@result1, @@result2 = [], []

Benchmark.bm LABELS.map(&:length).max do |x|
  x.report LABELS[0] do
    @@newcomers.each do |newcomer|
      distances = @@neighbors.map { |neighbor| euclidean_distance neighbor, newcomer }
      @@result1 << points[distances.index(distances.min)].inspect
    end
  end
  x.report LABELS[1] do
    kdtree = KDTree.new(@@neighbors)
    @@newcomers.each do |newcomer| 
      @@result2 << kdtree.nnearest(newcomer).location.inspect
    end
  end
end

require 'test/unit'
class TestBenchmark < Test::Unit::TestCase
  def test_results_match
    @@result1.each_with_index do |r1, i|
      assert_equal r1, @@result2[i], "i: #{i}, newcomer: #{@@newcomers[i].inspect}"
    end
  end
end

