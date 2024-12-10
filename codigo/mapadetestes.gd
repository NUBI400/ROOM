extends Node2D


func _ready() -> void:
	Global.criacao_no_pai = self
	
func _exit_tree() -> void:
	Global.criacao_no_pai = null
