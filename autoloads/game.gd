extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

@export var music: AudioStream

func _ready() -> void:
	if not music:
		Debug.log("Missing music")
		return
	music_player.stream = music
	music_player.play()


func play_sound(sound: AudioStream) -> void:
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = sound
	sound_player.bus = "SFX"
	add_child(sound_player)
	sound_player.play()
	await sound_player.finished
	sound_player.queue_free()
