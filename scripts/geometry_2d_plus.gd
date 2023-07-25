class_name Geometry2DPlus

## Returns a random point in the given polygon.
static func rand_point(polygon: PackedVector2Array) -> Vector2:
	var triangles = array_triangles(polygon)
	var triangle_table := WeightedTable.new()
	
	for triangle in triangles:
		triangle_table.add_item(triangle, triangle_area(triangle))
	
	var chosen_triangle: PackedVector2Array = triangle_table.pick_item()
	return rand_triangle_point(chosen_triangle)


## Returns the area of the given polygon.
static func area(polygon: PackedVector2Array) -> float:
	var res: float = 0.0
	var triangles = array_triangles(polygon)
	
	for triangle in triangles:
		res += triangle_area(triangle)
	
	return res


## Returns a random point in the triangle given an array of the points of the triangle
## Based on https://www.cs.princeton.edu/~funk/tog02.pdf
static func rand_triangle_point(points: PackedVector2Array) -> Vector2:
	assert(points.size() == 3)
	
	var a := points[0]
	var b := points[1]
	var c := points[2]
	
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))

# Returns the area of a triangle given an array of the points of the triangle
static func triangle_area(points: PackedVector2Array) -> float:
	assert(points.size() == 3)
	
	return 0.5 * (\
		(points[1].x - points[0].x) * (points[2].y - points[0].y) - \
		(points[2].x - points[0].x) * (points[1].y - points[0].y) \
	)


## Returns an array of polygons where each polygon is a triangle, based on
## triangulating the given polygon.
static func array_triangles(polygon: PackedVector2Array) -> Array[PackedVector2Array]:
	var res := [] as Array[PackedVector2Array]
	var triangulated_points := Geometry2D.triangulate_polygon(polygon)
	
	for index in len(triangulated_points) / 3:
		var triangle := [] as PackedVector2Array
		
		for n in range(3):
			triangle.append(polygon[triangulated_points[(index * 3) + n]])
		
		res.append(triangle)
	
	return res


## Returns a polygon based on the given indices and vertices
static func make_polygon(indices: PackedInt32Array, vertices: PackedVector2Array) -> PackedVector2Array:
	var res := [] as PackedVector2Array
	for idx in indices:
		res.append(vertices[idx])
	
	return res
