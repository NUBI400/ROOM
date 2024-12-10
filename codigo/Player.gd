extends CharacterBody2D

var multiplicador_dash = 6

var ghost_node = preload("res://cenas/ghost.tscn")
@onready var ghost_timer = $GhostTimer

const PARADO = 1
const ANDANDO = 2
const CORRENDO = 3

var estado_movimento = PARADO
var poderolar = false
var poderolarcorrendo = false
var velocidade = 50

func _ready():
	Global.player = self
func _exit_tree():
	Global.player = null
func _physics_process(delta):
	z_index = global_position.y
	
	
	var direcao = Input.get_vector("esquerda","direita","cima","baixo")
	
	velocity = direcao * velocidade 
	
	if estado_movimento == PARADO:
		funcao_parado()
	elif estado_movimento == ANDANDO:
		funcao_andando()
	elif estado_movimento == CORRENDO:
		funcao_correr()


	if (velocity == Vector2.ZERO):
		$AnimatedSprite2D.frame = 1 
		
	move_and_slide()
func funcao_parado():
	if Input.is_action_just_pressed("correr") and Global.estaminaplayer <= 0:
		estado_movimento = CORRENDO
		poderolar = false
	
	$AnimatedSprite2D.speed_scale = 1
	
	if Input.is_action_pressed("correr") and Global.estaminaplayer > 0: 
		estado_movimento = CORRENDO
	
	if abs(velocity.y) > abs(velocity.x):
		if velocity.y > 0:
			$AnimatedSprite2D.play("baixo")
			poderolar = true
		elif velocity.y < 0:
			$AnimatedSprite2D.play("cima")
			poderolar = true
	else:
		if velocity.x > 0:
			$AnimatedSprite2D.play("direita")
			$AnimatedSprite2D.flip_h = false
			poderolar = true
		elif velocity.x < 0:
			$AnimatedSprite2D.play("direita")
			$AnimatedSprite2D.flip_h = true
			poderolar = true
func funcao_andando():
	
	$AnimatedSprite2D.speed_scale = 1
	
	if velocity == Vector2.ZERO:
		estado_movimento = PARADO
		poderolar = false
		
	if Input.is_action_just_pressed("correr") and Global.estaminaplayer <= 0:
		estado_movimento = CORRENDO
		poderolar = false 
func funcao_correr():
	
	if abs(velocity.y) > abs(velocity.x):
		if velocity.y > 0:
			$AnimatedSprite2D.play("baixo")
			poderolarcorrendo = true
		elif velocity.y < 0:
			$AnimatedSprite2D.play("cima")
			poderolarcorrendo = true
	else:
		if velocity.x > 0:
			$AnimatedSprite2D.play("direita")
			$AnimatedSprite2D.flip_h = false
			poderolarcorrendo = true
		elif velocity.x < 0:
			$AnimatedSprite2D.play("direita")
			$AnimatedSprite2D.flip_h = true
			poderolarcorrendo = true
	
	Global.estaminaplayer -= 0.2
	Global.can_regen = false
	Global.s_timer = 0
	velocity *= 3
	
	$AnimatedSprite2D.speed_scale = 2
	
	if velocity == Vector2.ZERO:
		estado_movimento = PARADO
		poderolarcorrendo = false
	
	if Global.estaminaplayer <= 0:
		estado_movimento = ANDANDO
		Global.estaminaplayer = 0
		poderolarcorrendo = false
	
	if not Input.is_action_pressed("correr"):
		estado_movimento = ANDANDO
		poderolarcorrendo = false
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(ghost)
func _on_ghost_timer_timeout():
	add_ghost()
	print("aa")
func dash():
	ghost_timer.start()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "multiplicador_dash", 5, 0.8)
	await  tween.finished
	ghost_timer.stop()

	
	
	
