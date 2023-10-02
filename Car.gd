extends Node2D

var car: CharacterBody2D
var car_sprite: AnimatedSprite2D
var explosion_sprite: AnimatedSprite2D
var vector_drawing: Line2D

enum CarState {ACTIVE, INACTIVE, DESTROYED}

# I can't see a way to retrieve a list of the entity's available animations dynamically
# so I've stuck to hard coding them. 
var car_types = [
	'blue_car',
	'blue_car_1', 
	'green_car', 
	'orange_car', 
	'pink_car', 
	'police_car', 
	'red_car', 
	'turk_car', 
	'yellow_car'
]
var velocity_vector: Vector2 = Vector2(0,0)
var acceleration_vector: Vector2 = Vector2(0,0)
var start_position: Vector2 = Vector2(0,0)
var target_position: Vector2 = Vector2(0,0)
var car_state: CarState = CarState.INACTIVE
var should_move: bool = false
var interpolation_time: float = 0.0

 # These are used to set car facing
var modified_angle
var car_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_node('.')
	car_sprite = get_node("CarSprite")
	vector_drawing = get_node("MovementVectorDrawing")
	explosion_sprite = get_node("ExplosionSprite")
	randomize_car_type()
	explosion_sprite.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if car_state==CarState.ACTIVE:
		acceleration_vector = 24*Input.get_vector("move_left","move_right", "move_up","move_down")
		vector_drawing.set_point_position(1, acceleration_vector)
		# set_car_facing(acceleration_vector.angle()+PI)
	if should_move:
		interpolation_time += 3 * delta
		car.position = start_position.lerp(target_position, interpolation_time)
		if interpolation_time >= 1.0:
			interpolation_time = 0
			should_move = false

func _input(event):
	if car_state==CarState.ACTIVE:
		if event.is_action_pressed('accept'):
			car_state = CarState.INACTIVE
		if event.is_action_pressed('undo_move'):
			blow_up_car()
		
	
func set_car_facing(angle):
	modified_angle = fmod(angle, PI/2)
	car_direction = floor(2*angle/PI)
	car_sprite.set_frame(car_direction)
	car_sprite.set_rotation(modified_angle)


func change_car_sprite(sprite_name):
	# This seems like an awkward way to handle this but I think it's the simplest
	car_sprite.play(sprite_name)
	car_sprite.pause()


func randomize_car_type():
	change_car_sprite(car_types[randi_range(0,len(car_types)-1)])


func add_acceleration_and_move_car():
	velocity_vector += acceleration_vector
	start_position = car.position
	target_position = start_position + velocity_vector
	should_move = true
	set_car_facing(velocity_vector.angle()+PI)
	
	
func blow_up_car():
	# Show an explosion sprite and remove the car.
	explosion_sprite.show()
	explosion_sprite.play("explosion")
	$AudioStreamPlayer2D.play()
	car_sprite.hide()
	vector_drawing.hide()
	car_state = CarState.DESTROYED
	velocity_vector = Vector2(0,0)


	
func activate():
	# TODO: should handle destroyed cars properly
	car_state = CarState.ACTIVE
	
	
func is_destroyed():
	return car_state == CarState.DESTROYED
	

