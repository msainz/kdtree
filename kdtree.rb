
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
    nnearest!(@root, point, [ ], nnearest)
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
  
  def nnearest!(here, point, best, nnearest = 1)
    return best if here.nil?
    # if the current node is better than any of the current best, then it becomes a current best
    if best.length < nnearest or
      (ix = best.find_index { |b| distance(here.location, point) < distance(b, point) })
      ix ? best[ix] = here.location : best.push(here.location) 
    end
    # determine which branch contains the point along the split dimension
    nearer, farther = point[here.split] <= here.location[here.split] ? 
      [here.left, here.right] : [here.right, here.left]
    # search the nearer branch
    best = nnearest!(nearer, point, best, nnearest)
    # search the farther branch if the distance to the hyperplane is less than any best so far
    best = nnearest!(farther, point, best, nnearest) if
      best.find { |b| distance(b, point) >= distance([here.location[here.split]], [point[here.split]]) }
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
