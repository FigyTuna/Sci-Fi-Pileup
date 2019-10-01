extends Camera2D

var player

var zoom_amount = Vector2(0.06,0.06)

func _ready():
	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	if player:
		zoom = zoom_amount * player.velocity + Vector2(1,1)# + Vector2(4,4)
		$Node2D.position = Vector2(-25,-10) * player.velocity + Vector2(-382.38,-249.918)
		$Node2D.scale = Vector2(2,2) * (player.velocity / player.max_speed) + Vector2(2,2)
	else:
		player = get_parent()