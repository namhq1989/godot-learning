extends Node

signal on_plane_died

func emit_on_plane_died() -> void:
	on_plane_died.emit()


signal on_point_scored

func emit_on_point_scored() -> void:
	on_point_scored.emit()
