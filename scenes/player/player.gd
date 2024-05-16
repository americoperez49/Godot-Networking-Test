extends Node2D
@export var MultiplayerSync:MultiplayerSynchronizer
@export var PlayerNameLabel:Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

@rpc("any_peer","call_local")
func set_authority(id):
	PlayerNameLabel.text = GameManager.Players[id].Name
	set_multiplayer_authority(id)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if Input.is_action_pressed("ui_right"):
			global_position.x += 3
		if Input.is_action_pressed("ui_left"):
			global_position.x -= 3
		if Input.is_action_pressed("ui_down"):
			global_position.y += 3
		if Input.is_action_pressed("ui_up"):
			global_position.y -= 3
