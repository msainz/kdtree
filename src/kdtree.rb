
# "K-Dimensional Tree" and "N-Nearest Neighbors" implementation based on http://en.wikipedia.org/wiki/Kd-tree

class Node
  attr_reader :pivot, :spldim, :left, :right
  def initialize(pivot, spldim, left = nil, right = nil)
    @pivot, @spldim, @left, @right = 
      pivot, spldim, left, right
  end
end

class KDTree
  attr_reader :k, :root
  def initialize(points, depth = 0)
    @k = points.first.length # we assume all points have same dimension k
    @root = build(points, depth)
  end
  def nnearest(query, n = 1)
    nnearest!(@root, query, [ ], n)
  end
  private
  def build(points, depth = 0)
    return if points.empty?
    spldim = depth % @k
    points = points.sort { |m,n| m[spldim] <=> n[spldim] }
    pivot = points.length / 2 # make the pivot the median
    Node.new(points[pivot], spldim,
      build(points[0...pivot], depth + 1),
      build(points[pivot+1..-1], depth + 1))
  end
  
  def nnearest!(curr, query, nearest, n = 1)
    return nearest if curr.nil?
    # if the current node is better than any of the current nearest, then it becomes a current nearest
    if nearest.length < n
      nearest.push(curr.pivot)
    else
      dist_curr_query = distance(curr.pivot, query)
      ix = nearest.find_index { |b| dist_curr_query < distance(b, query) }
      nearest[ix] = curr.pivot if ix
    end
    # determine which branch contains the query along the split dimension
    nearer, farther = query[curr.spldim] <= curr.pivot[curr.spldim] ? 
      [curr.left, curr.right] : [curr.right, curr.left]
    # search the nearer branch
    nearest = nnearest!(nearer, query, nearest, n)
    # search the farther branch if the distance to the hyperplane is less than any nearest so far
    dist_curr_query_spldim = distance([curr.pivot[curr.spldim]], [query[curr.spldim]])
    nearest = nnearest!(farther, query, nearest, n) if
      nearest.find { |b| distance(b, query) >= dist_curr_query_spldim }
    # else no need to search the entire farther branch i.e. prune!
    nearest
  end  
  def distance m, n
    # squared euclidean distance (to avoid expensive sqrt operation)
    m.each_with_index.inject(0) { |tot, (coord, index)| tot += (coord - n[index]) ** 2 }
  end
end

# extensions for printing
class Node
  def to_a # inorder
     @left.to_a + [@pivot] + @right.to_a
  end
  def print l=0
     @right.print(l+1) if @right     
     puts("    "*l + @pivot.inspect)
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
