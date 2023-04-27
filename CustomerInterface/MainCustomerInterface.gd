extends HBoxContainer
@onready var database_interface_ref = get_parent().get_node("database_interface")
@onready var queryOutputRef = get_parent().currentData


# Called when the node enters the scene tree for the first time.
func _ready():
	print(database_interface_ref)
	database_interface_ref.handleQuery("SELECT B.ProductID, ProductName, Quantity, Cost FROM   [BAKED PRODUCT] AS B JOIN [PRODUCT INVENTORY] AS I ON B.ProductID = I.ProductID")
	print(queryOutputRef)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
