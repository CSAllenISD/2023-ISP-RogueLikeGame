extends CanvasLayer
const CHAR_READ_RATE = 0.02
onready var textboxcontainer = $TextBoxContainer
onready var start_symbol = $TextBoxContainer/MarginContainer2/HBoxContainer/Startsymbol
onready var end_symbol = $TextBoxContainer/MarginContainer2/HBoxContainer/Endsymbol
onready var label = $TextBoxContainer/MarginContainer2/HBoxContainer/text

enum State {
	READY,
	READING,
	FINISHED
}
var current_state = State.READY
var text_queue = []
func _ready():
	print("Starting State: state.READY")
	hide_text_box()
	
	#queue_text("Ill get those pesky plumbers")
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_text_box()
				#if text_queue == []:
					#get_tree().change_scene("res://RogueLikeGame/scenes/DEVTESTRoom.tscn")
				 

func queue_text(next_text):
	text_queue.push_back(next_text)


func hide_text_box():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textboxcontainer.hide()

func show_text_box():
	start_symbol.text = ">"
	textboxcontainer.show()

func display_text():
	label.percent_visible = 0.0
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_text_box()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, $Tween.TRANS_LINEAR, $Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed():
	end_symbol.text = ""
	change_state(State.FINISHED)
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("CHanGinG STaTe To state.READY")
		State.READING:
			print("CHanGinG STaTe To state.READING")
		State.FINISHED:
			print("CHanGinG STaTe To state.FINISHED")
			
func _enter():
	hide_text_box()
