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
		newProductRow.set_meta("productId", row[0])
		$MainScrollVBoxContainer/ScrollContainer/RowContainer.add_child(newProductRow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_search_bar_text_submitted(new_text):
	if new_text == "":
		print("empty")
	elif new_text.is_valid_int():
		database_interface_ref.handleQuery(str("SELECT B.ProductID, ProductName, Quantity, Cost
		FROM   [BAKED PRODUCT] AS B JOIN [PRODUCT INVENTORY] AS I
					   ON B.ProductID = I.ProductID WHERE B.ProductID = ", new_text))
		#clear current rows for new searched row
		for rowEntry in $MainScrollVBoxContainer/ScrollContainer/RowContainer.get_children():
			$MainScrollVBoxContainer/ScrollContainer/RowContainer.remove_child(rowEntry)
		var newProductRow = load("res://GUIRow/ProductEntry.tscn").instantiate()
		newProductRow.get_node("ProductEntry/Label").text = get_parent().currentData[0][1]
		newProductRow.set_meta("productId", get_parent().currentData[0][0]) 
		$MainScrollVBoxContainer/ScrollContainer/RowContainer.add_child(newProductRow)
		
	else:
		database_interface_ref.handleQuery(str("SELECT B.ProductID, ProductName, Quantity, Cost
		FROM   [BAKED PRODUCT] AS B JOIN [PRODUCT INVENTORY] AS I
					   ON B.ProductID = I.ProductID WHERE ProductName = '", new_text, "'"))
		for rowEntry in $MainScrollVBoxContainer/ScrollContainer/RowContainer.get_children():
			$MainScrollVBoxContainer/ScrollContainer/RowContainer.remove_child(rowEntry)
		var newProductRow = load("res://GUIRow/ProductEntry.tscn").instantiate()
		newProductRow.get_node("ProductEntry/Label").text = get_parent().currentData[0][1]
		newProductRow.set_meta("productId", get_parent().currentData[0][0]) 
		$MainScrollVBoxContainer/ScrollContainer/RowContainer.add_child(newProductRow)
		
		
func AddToCartPushed(itemBeingAdded):
	var newCartProduct = load("res://GUIRow/CartProductEntry.tscn").instantiate()
	var isFound = false
	for productRow in $VBoxContainer4/ScrollContainer/VBoxContainer.get_children():
		if productRow.get_node("VBoxContainer/Label").text == itemBeingAdded.get_node("ProductEntry/Label").text:
			productRow.get_node("VBoxContainer/HBoxContainer/SpinBox").value += itemBeingAdded.get_node("ProductEntry/SpinBox").value
			isFound = true
	if !isFound:
		newCartProduct.get_node("VBoxContainer/Label").text = itemBeingAdded.get_node("ProductEntry/Label").text
		newCartProduct.get_node("VBoxContainer/HBoxContainer/SpinBox").value += itemBeingAdded.get_node("ProductEntry/SpinBox").value
		get_node("/root/Main/MainCustomerExperience/VBoxContainer4/ScrollContainer/VBoxContainer").add_child(newCartProduct)
	
		


func _on_checkout_button_pressed():
	pass # Replace with function body.
