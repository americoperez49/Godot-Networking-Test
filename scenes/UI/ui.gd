extends Control

var IP_ADDRESS = "localhost"
var PORT = 8910
var MAX_NUMBER_OF_PLAYERS = 2
var peer:ENetMultiplayerPeer
@export var player_name_input_field:LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

#called on server and client
func _on_peer_connected(ID):
	_who_created_this_message()
	print("Peer connected: " + str(ID) + "\n")
	
#called on server and client
func _on_peer_disconnected(ID):
	_who_created_this_message()
	print("Peer disconnected: " + str(ID) + "\n")

#only called on client
func _on_connected_to_server():
	_who_created_this_message()
	print("conntected to server" + "\n")
	send_player_data.rpc_id(1,multiplayer.get_unique_id(),player_name_input_field.text)

#only called on client
func _on_connection_failed():
	_who_created_this_message()
	print("connection failed" + "\n")

@rpc("any_peer","call_local","reliable")		
func start_game():
	var scene:PackedScene = load("res://scenes/main/main.tscn") as PackedScene
	get_tree().root.add_child(scene.instantiate())
	hide()

@rpc("any_peer")
func send_player_data(ID,Name):
	if !GameManager.Players.has(ID):
		GameManager.Players[ID]= {
			"ID":ID,
			"Name":Name
		}
	if multiplayer.is_server():
		for id in GameManager.Players:
			send_player_data.rpc(id,GameManager.Players[id].Name)
			print()

		

func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT,MAX_NUMBER_OF_PLAYERS)
	if error != OK:
		print("cannot host: " + error)
		return
	
	multiplayer.multiplayer_peer=peer
	_who_created_this_message()
	print("waiting for other players" + "\n")
	
	#only add this here if you are using P2P networking
	send_player_data(multiplayer.get_unique_id(),player_name_input_field.text)



func _on_join_button_pressed():
	peer =ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS,PORT)
	multiplayer.multiplayer_peer=peer



func _on_start_game_button_pressed():
	start_game.rpc()
	pass # Replace with function body.
	
func _who_created_this_message():
	print ("Peer " + str(peer.get_unique_id()) + " created the following message:")
