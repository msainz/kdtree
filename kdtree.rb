
# "K-Dimensional Tree" and "N-Nearest Neighbors" implementation based on http://en.wikipedia.org/wiki/Kd-tree

class Node
  attr_reader :location, :axis, :left_child, :right_child
  def initialize location, axis, left_child = nil, right_child = nil
    @location, @axis, @left_child, @right_child = 
      location, axis, left_child, right_child
  end
end

class KDTree
  attr_reader :k, :root
  def initialize points, depth = 0
    @k = points.first.length # we assume all points have same dimension k
    @root = build_kdtree points, depth
  end
  def nearest_neighbors point, nnearest = 1
    search_nearest_neighbors @root, point, nil, nnearest
  end
  private
  def build_kdtree points, depth = 0
    return if points.empty?
    axis = select_axis depth
    pivot = select_pivot points, axis
    Node.new(points[pivot], axis,
      build_kdtree(points[0...pivot], depth + 1),
      build_kdtree(points[pivot+1..-1], depth + 1))
  end
  def select_axis depth
    depth % @k
  end
  def select_pivot points, axis
    points.sort! { |m,n| m[axis] <=> n[axis] }
    points.length / 2 # make the pivot the median
  end
  
  # TODO: provide the k-Nearest Neighbours to a point by maintaining k current bests instead of just one.
  # Branches are only eliminated when they can't have points closer than any of the k current bests.
  def search_nearest_neighbors here, point, best, nnearest = 1
    return best if here.nil?
    best = here if best.nil? || distance(here.location, point) < distance(best.location, point)
    # search the nearer branch
    child = nearer_child here, point
    best = search_nearest_neighbors child, point, best
    # search the farther branch if the distance to the hyperplane is less than the best so far
    if distance_to_hyperplane(here.location, point, here.axis) < distance(best.location, point)
      child = farther_child here, point
      best = search_nearest_neighbors child, point, best
    end
    # else no need to search in that whole branch i.e. prune!
    best
  end
  def nearer_child here, point
    nearer_or_farther_child here, point, :<
  end
  def farther_child here, point
    nearer_or_farther_child here, point, :>=
  end
  def nearer_or_farther_child here, point, op
    return here.left_child if here.right_child.nil?
    return here.right_child if here.left_child.nil?
    distance(here.left_child.location, point).send(op, distance(here.right_child.location, point)) ?
      here.left_child : here.right_child
  end  
  def distance m, n
    # we'll use squared euclidean distance (to avoid expensive sqrt operation)
    # Ruby 1.9: m.each_with_index.inject(0) { |tot, (coord, index)| tot += (coord - n[index]) ** 2 }
    sum_of_squares = 0
    m.each_with_index { |coord, index| sum_of_squares += (coord - n[index]) ** 2 }
    sum_of_squares
  end
  def distance_to_hyperplane m, n, axis
    (m[axis] - n[axis]) ** 2
  end
end
