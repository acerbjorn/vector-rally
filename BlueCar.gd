extends Node2D

var car_sprite
var car_rotation
var vector_drawing

var acceleration_vector

 # These are used to set car facing
var modified_angle
var car_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	car_sprite = get_node("CarSprite")
	vector_drawing = get_node("MovementVectorDrawing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#car_rotation =
	acceleration_vector = Input.get_vector("move_left","move_right", "move_up","move_down")
	vector_drawing.set_point_position(1, 20*acceleration_vector)
	set_car_facing(acceleration_vector.angle()+PI)
	
	
func set_car_facing(angle):
	# TODO: virker men bilens vinkel er forkert så det skal fikses
	modified_angle = fmod(angle, PI/2)
	car_direction = floor(2*angle/PI)
	car_sprite.set_frame(car_direction)
	car_sprite.set_rotation(modified_angle)
	
	
