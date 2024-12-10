extends CharacterBody2D


@onready var navReg = $"../NavigationRegion2D"
@onready var nav = get_node("NavigationAgent2D")

var speed = 100
var path = []
var map 

func _ready():
	call_deferred("setup_navserver")

func _unhandled_input(event):
	if not event.is_action_pressed("LeftClick"):
		return
	_update_navigation_path(self.position, get_global_mouse_position())

func setup_navserver():
	
	map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(map, true)
	
	
	var region = NavigationServer2D.region_create()
	NavigationServer2D.region_set_transform(region, Transform2D())
	NavigationServer2D.region_set_map(region, map)
	
	
	var navigation_poly = NavigationMesh.new()
	navigation_poly = $"../NavigationRegion2D".navigation_polygon
	NavigationServer2D.region_set_navigation_polygon(region, navigation_poly)

func _update_navigation_path(start_position, end_position):
	path = NavigationServer2D.map_get_path(map,start_position, end_position, true)
	print(path)
	get_node("../Line2D").clear_points()
	for i in path:
		get_node("../Line2D").add_point(i)
	
	path.remove_at(0)
	set_process(true)

func _process(delta):
	var walk_distance = 100 * delta
	move_along_path(walk_distance)

func move_along_path(distance):
	
	var last_point = self.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			self.position = last_point.lerp(path[0], distance / distance_between_points)
			return
	
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	self.position = last_point
	set_process(false)
	
	
	
	
