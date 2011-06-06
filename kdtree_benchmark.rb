
require './kdtree.rb'
require 'benchmark'

point = [rand, rand]
points = []
1000.times { |i| points << [rand, rand] }  

def euclidean_distance m, n
  Math.sqrt( m.each_with_index.inject(0) { |tot, (coord, index)| tot += (coord - n[index]) ** 2 } )
end

Benchmark.bm(7) do |x|
  x.report('trivial 1NN search') do
    10000.times do |i|
      distances = points.map { |p| euclidean_distance p, point }
      @@result1 = points[distances.index(distances.min)].inspect
    end
  end
  x.report('kdtree 1NN search') do
    kdtree = KDTree.new(points)
    10000.times do |i| 
      @@result2 = kdtree.nearest_neighbors(point).location.inspect
    end
  end
end

require 'test/unit'
class TestBenchmark < Test::Unit::TestCase
  def test_results_match
    assert_equal @@result1, @@result2
  end
end

