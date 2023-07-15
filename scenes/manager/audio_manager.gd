extends Node2D

@onready var audio_dictionary: Dictionary
@onready var heart_beat: AudioStreamPlayer2D = $heart_beat

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.sound_made.connect(play_audio)
	

func _init():
	# Accessing audio directory and making a dictionary
	var audio_directory: DirAccess = DirAccess.open("res://assets/audio/")
	audio_directory.list_dir_begin()
	var audio: String = audio_directory.get_next()
	while audio != "":
		if audio.ends_with(".mp3") or audio.ends_with(".wav"):
			var path_name: String = "res://assets/audio/" + audio
			var audio_stream: AudioStream = load(path_name)
			audio_dictionary[audio.get_slice(".", 0)] = audio_stream
		audio = audio_directory.get_next()
	
	audio_directory.list_dir_end()



func play_audio(audio: String, volume_db: float, pitch_scale: float) -> void:
	var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	var audio_stream: AudioStream = audio_dictionary[audio]
	audio_stream_player.stream = audio_stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale
	add_child(audio_stream_player)
	audio_stream_player.play()
	
	while(audio_stream_player.playing):
		await get_tree().create_timer(audio_stream.get_length(), false).timeout
	remove_audio(audio_stream_player)

func remove_audio(child: AudioStreamPlayer2D) -> void:
	remove_child(child)

func change_background(audio: String, volume_db: float, pitch_scale: float) -> void:
	var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	var audio_stream: AudioStream = audio_dictionary[audio]
	audio_stream_player.stream = audio_stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale