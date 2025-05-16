extends GPUParticles2D

var _begin: Vector2
var _started = false


func _ready() -> void:
	if _started:
		_emit()


func start(begin: Vector2, end: Vector2) -> void:
	_begin = begin
	var dist = begin.distance_to(end)
	var ppm = process_material as ParticleProcessMaterial
	if not ppm:
		return
	ppm.emission_box_extents = Vector3.RIGHT * dist / 2
	ppm.emission_shape_offset = ppm.emission_box_extents
	global_rotation = begin.direction_to(end).angle()
	var up_direction = Vector2.UP.rotated( -global_rotation)
	ppm.direction = Vector3(up_direction.x, up_direction.y, 0)
	_started = true
	if is_node_ready():
		_emit()


func _emit() -> void:
	global_position = _begin
	emitting = true
	await finished
	queue_free()
