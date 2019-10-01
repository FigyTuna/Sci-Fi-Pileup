extends Node2D

export (Array, NodePath)var checkpoint_paths

export (NodePath)var player_path

export (Array, NodePath)var opponent_paths

var checkpoints = []
var player
var opponents = []

var lap_timer = 0
var prev_lap = 99
var prev_prev_lap = 99

var best_lap = 99
var best_three = 99

var started = false

var hard_mode = false

func _ready():
	for p in checkpoint_paths:
		checkpoints.append(get_node(p))
	player = get_node(player_path)
	for p in opponent_paths:
		opponents.append(get_node(p))
	player.connect("pass_cp", self, "proc_cp")
	for o in opponents:
		o.connect("pass_cp", self, "proc_cp")
		o.cp = checkpoints.find(o.get_child(2).next_cp)
	
	checkpoints[0].turn_on()

func proc_cp(car, index, cp):
	if checkpoints.find(cp) == index:
		if car == player:
			car.update_cp((index + 1) % 8)
			cp.reset()
			checkpoints[(index + 1) % 8].turn_on()
			if started:
				pass#$cp.play()
		else:
			if hard_mode:
				car.update_cp((index + 7) % 8)
				car.get_child(2).next_cp = checkpoints[(index + 7) % 8]
			else:
				car.update_cp((index + 1) % 8)
				car.get_child(2).next_cp = checkpoints[(index + 1) % 8]
		if car == player and index == 0:
			if started and lap_timer < best_lap:
				best_lap = lap_timer
				$record.play()
			if started and prev_prev_lap + prev_lap + lap_timer < best_three:
				best_three = prev_prev_lap + prev_lap + lap_timer
				$record.play()
			if started:
				prev_prev_lap = prev_lap
				prev_lap = lap_timer
			lap_timer = 0
			started = true

func _physics_process(delta):
	
	if player.velocity > 2 and player.velocity < 10:
		if not $go.playing:
			$go.play()
	if player.velocity > 2:
		$go.pitch_scale = (player.velocity / player.max_speed) * 0.7
	
	if started:
		lap_timer += delta
	
	$Player/Camera2D/Node2D/Label.text = "  Lap: " + sec(lap_timer) + ":" + ms(lap_timer) + " / Best: " + sec(best_lap) + ":" + ms(best_lap) + "\nBest 3 laps in a row: " + sec(best_three) + ":" + ms(best_three)

func sec(n):
	if n < 10:
		return "0" + str(int(n))
	return str(int(n))

func ms(n):
	var s = (str((n - int(n)) * 60 / 100) + ".00").split('.')
	if len(s[1]) < 2:
		return s[2]
	return s[1].substr(0,2)

func hard():
	if not hard_mode:
		hard_mode = true
		for o in opponents:
			o.rotation_degrees += 180
			o.velocity = 0
			o.update_cp((o.cp + 7) % 8)
			o.get_child(2).next_cp = checkpoints[o.cp]