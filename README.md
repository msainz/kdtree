Ruby k-d tree
=============

Ruby implementation of "K-Dimensional Tree" and "N-Nearest Neighbors" based on [http://en.wikipedia.org/wiki/Kd-tree](http://en.wikipedia.org/wiki/Kd-tree).

##API
#####Initialize
Build a new tree on a set of (2 or higher dimensional) coordinates:

```ruby
points = [[2,3], [5,4], [9,6], [4,7], [8,1], [7,2]]
kdtree = KDTree.new points
```

#####Flatten
Get an inorder representation as an array
```ruby
kdtree.to_a
=> [[2, 3], [5, 4], [4, 7], [7, 2], [8, 1], [9, 6]]
```
#####Print
```ruby
kdtree.print
=>
    [9, 6]
        [8, 1]
[7, 2]
        [4, 7]
    [5, 4]
        [2, 3]
```
#####Nearest Neighbors
Current implementation uses squared euclidean as distance metric.
That is, for any 2 points a and b in D-dimensional space:
![equation](http://latex.codecogs.com/gif.latex?%5Csum_%7Bd%3D1%7D%5E%7BD%7D%28a_d-b_d%29%5E2)
#####1-NN
```ruby
kdtree.nnearest([1,1])
=> [[2, 3]]
```
#####k-NN
```ruby
kdtree.nnearest([1,1],3)
=> [[7, 2], [5, 4], [2, 3]]
```
