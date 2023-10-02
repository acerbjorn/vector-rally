extends Node2D

@export_group("Racer")
@export var car_node: PackedScene
@export var start_x: int = 0
@export var start_y: int = 0
@export var car_amount: int = 1


var car_list: Array
var active_car: int
var has_found_activatable_car: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(car_amount):
		var car = car_node.instantiate()
		car.set_position(Vector2(start_x, start_y))
		add_child(car)
		car_list.push_back(car)
		
	
	car_list[0].activate()
	

func _input(event):
	if event.is_action_pressed("accept"):
		$AudioStreamPlayer.play()
		OS.delay_msec(400) # This sleep should probably be a signal instead
		# To properly hide 
		active_car += 1
		while !has_found_activatable_car:
			if active_car >= len(car_list):
				# We've iterated over all the cars and it's time to move all cars
				move_all_cars()
				active_car = 0
			
			if car_list[active_car].is_destroyed():
				active_car += 1
			else:
				has_found_activatable_car = true
			
		car_list[active_car].activate()
		has_found_activatable_car = false



func move_all_cars():
	for car in car_list:
		car.add_acceleration_and_move_car()


func _on_area_2d_body_entered(body):
	if body.has_method("blow_up_car"):
		body.blow_up_car()
