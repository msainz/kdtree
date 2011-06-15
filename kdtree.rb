
# "K-Dimensional Tree" and "N-Nearest Neighbors" implementation based on http://en.wikipedia.org/wiki/Kd-tree

class Node
  attr_reader :location, :split, :left, :right
  def initialize(location, split, left = nil, right = nil)
    @location, @split, @left, @right = 
      location, split, left, right
  end
end

class KDTree
  attr_reader :k, :root
  def initialize(points, depth = 0)
    @k = points.first.length # we assume all points have same dimension k
    @root = build(points, depth)
  end
  def nnearest(point, nnearest = 1)
    nnearest!(@root, point, nil, nnearest)
  end
  private
  def build(points, depth = 0)
    return if points.empty?
    split = depth % @k
    points = points.sort { |m,n| m[split] <=> n[split] }
    pivot = points.length / 2 # make the pivot the median
    Node.new(points[pivot], split,
      build(points[0...pivot], depth + 1),
      build(points[pivot+1..-1], depth + 1))
  end
  
  # TODO: provide the N-Nearest Neighbours to a point by maintaining N current bests instead of just one.
  # Branches are only eliminated when they can't have points closer than any of the N current bests.
  def nnearest!(here, point, best, nnearest = 1)
    return best if here.nil?
    # if the current node is better than the current best, then it becomes the current best
    best = here if best.nil? || distance(here.location, point) < distance(best.location, point)
    # determine which branch contains the point along the split dimension
    nearer, farther = point[here.split] <= here.location[here.split] ? 
      [here.left, here.right] : [here.right, here.left]
    # search the nearer branch
    best = nnearest!(nearer, point, best)
    # search the farther branch if the distance to the hyperplane is less than the best so far
    best = nnearest!(farther, point, best) if
      distance([here.location[here.split]], [point[here.split]]) <= distance(best.location, point)
    # else no need to search the entire farther branch i.e. prune!
    best
  end  
  def distance m, n
    # squared euclidean distance (to avoid expensive sqrt operation)
    m.each_with_index.inject(0) { |tot, (coord, index)| tot += (coord - n[index]) ** 2 }
  end
end

# extensions for printing
class Node
  def to_a # inorder
     @left.to_a + [@location] + @right.to_a
  end
  def print l=0
     @right.print(l+1) if @right     
     puts("    "*l + @location.inspect)
     @left.print(l+1) if @left
  end
end

class KDTree
  def to_a
    @root.to_a
  end
  def print
    @root.print
  end
end
