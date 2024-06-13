extends Node2D

const PORT := 4433

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	
	multiplayer.server_relay = false
	
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		print("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()


func _on_connect_pressed() -> void:
	var txt : String = $UI/Net/Options/Remote.text
	if txt == "":
		print("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		print("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()
	
	
func start_game():
	$UI.hide()
	get_tree().paused = false
