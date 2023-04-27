extends HBoxContainer
@onready var database_interface_ref = get_parent().get_node("database_interface")



# Called when the node enters the scene tree for the first time.
func _ready():
	database_interface_ref.handleQuery("INSERT INTO [CUSTOMER]
VALUES (4, John Doe, (444) 444-4444, 444 Lane, jdoe04)")
	print(get_parent().currentData)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
