class_name PowerUp
extends Area2D
## Cápsula coleccionable que otorga bolas especiales o ventajas utilitarias.

enum Type {
	MULTI_BALL,   # 0: Divide la bola en 3
	FIRE,         # 1: Bola de fuego atravesadora
	ACID,         # 2: Bola ácida (2x daño)
	HEAVY,        # 3: Bola pesada / gigante
	LIGHTNING,    # 4: Bola rayo
	STICKY,       # 5: Bola pegajosa a la paleta
	GHOST,        # 6: Bola fantasma
	SONIC,        # 7: Bola sónica (3x puntos)
	SLOW,         # 8: Bola lenta de precisión
	EXTRA_LIFE,   # 9: +1 Vida
	SHIELD        # 10: Barrera inferior
}

@export var fall_speed: float = 180.0
@onready var sprite: Sprite2D = $Sprite2D

var power_type: Type = Type.MULTI_BALL
var base_color: Color = Color.WHITE

## Puntos de aparición: coordenada desde donde cae la cápsula.
var source_brick: String = ""


func setup(t: Type) -> void:
	power_type = t
	match power_type:
		Type.MULTI_BALL:
			sprite.modulate = Color(0.2, 0.9, 1.0) # Celeste brillante
		Type.FIRE:
			sprite.modulate = Color(1.0, 0.2, 0.0) # Rojo ardiente
		Type.ACID:
			sprite.modulate = Color(0.3, 1.0, 0.1) # Verde ácido
		Type.HEAVY:
			sprite.modulate = Color(0.7, 0.7, 0.8) # Gris metálico
		Type.LIGHTNING:
			sprite.modulate = Color(1.0, 0.95, 0.2) # Amarillo rayo
		Type.STICKY:
			sprite.modulate = Color(0.9, 0.3, 0.9) # Magenta
		Type.GHOST:
			sprite.modulate = Color(0.6, 0.8, 1.0) # Blanco azulado
		Type.SONIC:
			sprite.modulate = Color(0.1, 0.5, 1.0) # Azul cobalto
		Type.SLOW:
			sprite.modulate = Color(0.4, 0.9, 0.9) # Turquesa
		Type.EXTRA_LIFE:
			sprite.modulate = Color(1.0, 0.2, 0.5) # Rosa corazón
		Type.SHIELD:
			sprite.modulate = Color(0.0, 0.8, 0.9) # Azul barrera
		_:
			sprite.modulate = Color.WHITE


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > 750.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Paddle or body.name == "Paddle":
		var main_node = get_tree().current_scene
		if main_node and main_node.has_method("activate_power_up"):
			main_node.activate_power_up(power_type)
		queue_free()
