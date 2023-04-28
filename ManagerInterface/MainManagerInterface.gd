extends HBoxContainer

@onready var database_interface_ref = get_parent().get_node("database_interface")
# Called when the node enters the scene tree for the first time.
func _ready():
	# filling out the products tab
	database_interface_ref.handleQuery("SELECT B.ProductID, ProductName, Quantity, Cost
	FROM   [BAKED PRODUCT] AS B JOIN [PRODUCT INVENTORY] AS I
					   ON B.ProductID = I.ProductID")
	var newProductRowResource = load("res://GUIRow/ProductEntry.tscn")
	for row in get_parent().currentData:
		var newProductRow = newProductRowResource.instantiate()
		newProductRow.get_node("ProductEntry/Label").text = row[1] + " ($" + row[3] + ")"
		newProductRow.set_meta("productId", row[0])
		newProductRow.set_meta("price", row[3])
		# set the quantity
		newProductRow.get_node("ProductEntry/SpinBox").value = int(row[2])
		$VBoxContainer/TabContainer/Products/ScrollContainer/RowContainer.add_child(newProductRow)
		
	
	# filling out the materials tab
	database_interface_ref.handleQuery("SELECT M.Material_ID, MaterialName, ExpirationDate, [Count]
	FROM [BAKING MATERIAL] AS M JOIN [MATERIALS INVENTORY] AS I 
							  ON M.Material_ID = I.Material_ID")
	
	var newMaterialRowResource = load("res://GUIRow/MaterialEntry.tscn")
	for row in get_parent().currentData:
		var newMaterialRow = newMaterialRowResource.instantiate()
		newMaterialRow.set_meta("materialId", row[0])
		newMaterialRow.set_meta("materialName", row[1])
		newMaterialRow.set_meta("expirationDate", row[2])
		newMaterialRow.set_meta("count", row[3])
		
		newMaterialRow.get_node("Label").text = row[1] + " (exp: " + str(row[2]) + ")"
		newMaterialRow.get_node("SpinBox2").value = int(row[3])
		$VBoxContainer/TabContainer/Materials/ScrollContainer/RowContainer.add_child(newMaterialRow)
		
		
	#filling out the orders tab
	database_interface_ref.handleQuery("SELECT O.OrderID, CustomerNumber, OrderDate, 
											   TotalDue, ProductName, Quantity
									 FROM [ORDER] AS O JOIN [ORDER ITEM] AS I
													   ON O.OrderID = I.OrderID
													JOIN [BAKED PRODUCT] AS P
												ON I.ProductID = P.ProductID")
												
	var newOrderRowResource = load("res://GUIRow/OrderEntry.tscn")
	for row in get_parent().currentData:
		print(row)
		var newOrderRow = newOrderRowResource.instantiate()
		newOrderRow.set_meta("orderId", row[0])
		newOrderRow.set_meta("customerNumber", row[1])
		newOrderRow.set_meta("orderDate", row[2])
		newOrderRow.set_meta("totalDue", row[3])
		newOrderRow.set_meta("productName", row[4])
		newOrderRow.set_meta("quantity", row[5])
		
		newOrderRow.get_node("VBoxContainer/ProductEntry/Label").text = "O:" + row[0]
		newOrderRow.get_node("VBoxContainer/ProductEntry/Label2").text = "Cn:" + row[1]
		newOrderRow.get_node("VBoxContainer/ProductEntry/Label3").text = "Date: " + row[2]
		newOrderRow.get_node("VBoxContainer/ProductEntry/Label4").text = "Cost: $" + row[3]
		newOrderRow.get_node("VBoxContainer/ProductEntry/Label5").text = "Prod:" + row[4]
		newOrderRow.get_node("VBoxContainer/ProductEntry/SpinBox").value = int(row[5])
		$VBoxContainer/TabContainer/Orders/ScrollContainer/RowContainer.add_child(newOrderRow)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
