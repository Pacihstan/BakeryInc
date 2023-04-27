extends HBoxContainer
@onready var database_interface_ref = get_parent().get_node("database_interface")



# Called when the node enters the scene tree for the first time.
func _ready():
	database_interface_ref.handleQuery("SELECT B.ProductID, ProductName, Quantity, Cost
FROM   [BAKED PRODUCT] AS B JOIN [PRODUCT INVENTORY] AS I
					   ON B.ProductID = I.ProductID")
	var newProductRowResource = load("res://GUIRow/ProductEntry.tscn")
	for row in get_parent().currentData:
		var newProductRow = newProductRowResource.instantiate()
		newProductRow.get_node("ProductEntry/Label").text = row[1]
		$MainScrollVBoxContainer/ScrollContainer/RowContainer.add_child(newProductRow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
