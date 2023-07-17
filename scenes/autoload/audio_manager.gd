extends Node2D

@onready var audio_dictionary: Dictionary
	

func _init():
	# Accessing audio directory and making a dictionary
	var audio_directory: DirAccess = DirAccess.open("res://assets/audio/")
	audio_directory.list_dir_begin()
	var file_name: String = audio_directory.get_next()
	while file_name != "":
		if file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
			var path_name: String = "res://assets/audio/" + file_name
			var audio_stream: AudioStream = load(path_name)
			audio_dictionary[file_name.get_slice(".", 0)] = audio_stream
		file_name = audio_directory.get_next()
	
	audio_directory.list_dir_end()



func play_audio(audio: String, volume_db: float, pitch_scale: float = 1.0) -> void:
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	var audio_stream: AudioStream = audio_dictionary[audio]
	audio_stream_player.stream = audio_stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale
	add_child(audio_stream_player)
	audio_stream_player.play()
	
	audio_stream_player.finished.connect(remove_audio.bind(audio_stream_player))


func remove_audio(child: AudioStreamPlayer) -> void:
	remove_child(child)
