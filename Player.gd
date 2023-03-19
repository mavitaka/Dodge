extends Area2D
signal	hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window


func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.

	if InputEventScreenTouch:
		var touch_pos = get_viewport().get_mouse_position()
		var player_pos = position
		var direction = (touch_pos - player_pos).normalized()
		velocity = direction * speed

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
