extends CharacterBody2D

@export var speed: int

var velocidade = Vector2.ZERO

var atordoado = false

@export var recuo: int 

@export var hp: int

@export var cor : String

var home_pos = Vector2.ZERO

@onready var cor_atual = modulate

@export var player: Node2D

@export var nav_agent : NavigationAgent2D

var parado = false

func _ready():
	var recuo = get_node("Recuo")
	recuo.timeout.connect(_on_recuo_timeout)
	
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _process(delta: float) -> void:
	animation()
	
	if parado == false:
		$AnimatedSprite2D.frame = 1 
	movimento_basico_inimigo(delta)

func movimento_basico_inimigo(delta):
	if Global.player != null and atordoado == false and parado == true:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed 
		move_and_slide()
#		velocidade = global_position.direction_to(Global.player.global_position)
#		global_position += velocidade * speed * delta

	elif atordoado:
		velocity = lerp(velocidade, Vector2.ZERO,0.3)
		global_position += velocidade * delta


	if hp <= 0 and Global.criacao_no_pai != null:
		if Global.camera != null:
			Global.camera.tremer_tela(80, 0.2)
			queue_free()

func makepath() -> void:
	if not player == null:
		nav_agent.target_position = player.global_position

func _on_timermakepath_timeout():
	makepath()

func animation():
	
	if (velocity == Vector2.ZERO):
		$AnimatedSprite2D.frame = 1 
	
	if abs(velocity.y) > abs(velocity.x):
		if velocity.y > 0:
			$AnimatedSprite2D.play("baixo")
		elif velocity.y < 0:
			$AnimatedSprite2D.play("cima")
	else:
		if velocity.x > 0:
			$AnimatedSprite2D.play("direita")
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite2D.play("direita")
			$AnimatedSprite2D.flip_h = true
	
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_damage") and (atordoado == false || cor == "Branco"):
		modulate = Color.WHITE
		area.get_parent().queue_free()
		velocity = -velocity * recuo
		atordoado = true
		hp -= 1 
		$Recuo.start()
func _on_recuo_timeout() -> void:
	modulate = cor_atual
	atordoado = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		parado = true


func _on_saiu_body_exited(body):
	if body.is_in_group("player"):
		parado = false
