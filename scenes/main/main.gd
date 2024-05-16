extends Node2D
@export var PlayerScene:PackedScene
@export var SpawnLocations:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer:Node2D = PlayerScene.instantiate() as Node2D
		add_child(currentPlayer,true)
		for spawn:Node2D in SpawnLocations.get_children():
			if spawn.name == str(index):
				if index == 0: currentPlayer.modulate= Color.DARK_RED
				else: currentPlayer.modulate = Color.MEDIUM_BLUE
				currentPlayer.global_position = spawn.global_position
				currentPlayer.set_authority.rpc(i)
		index+=1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
