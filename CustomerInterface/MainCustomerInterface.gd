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
		newProductRow.get_node("ProductEntry/Label").text = row[1] + " ($" + row[3] + ")"
		newProductRow.set_meta("productId", row[0])
		newProductRow.set_meta("price", row[3])
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
		newProductRow.set_meta("price", get_parent().currentData[0][3])
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
		newProductRow.set_meta("price", get_parent().currentData[0][3])
		$MainScrollVBoxContainer/ScrollContainer/RowContainer.add_child(newProductRow)
		
		
func AddToCartPushed(itemBeingAdded):
	var newCartProduct = load("res://GUIRow/CartProductEntry.tscn").instantiate()
	var isFound = false
	for productRow in $VBoxContainer4/ScrollContainer/VBoxContainer.get_children():
		if productRow.get_node("VBoxContainer/Label").text == itemBeingAdded.get_node("ProductEntry/Label").text:
			productRow.get_node("VBoxContainer/HBoxContainer/SpinBox").value += itemBeingAdded.get_node("ProductEntry/SpinBox").value
			productRow.set_meta("price", itemBeingAdded.get_meta("price"))
			productRow.set_meta("productId", itemBeingAdded.get_meta("productId"))
			isFound = true
	if !isFound:
		newCartProduct.get_node("VBoxContainer/Label").text = itemBeingAdded.get_node("ProductEntry/Label").text
		newCartProduct.get_node("VBoxContainer/HBoxContainer/SpinBox").value += itemBeingAdded.get_node("ProductEntry/SpinBox").value
		newCartProduct.set_meta("price", itemBeingAdded.get_meta("price"))
		newCartProduct.set_meta("productId", itemBeingAdded.get_meta("productId"))
		get_node("/root/Main/MainCustomerExperience/VBoxContainer4/ScrollContainer/VBoxContainer").add_child(newCartProduct)
	#come back
	$VBoxContainer4/TotalContainer/TotalPrice.value = 0
	for productRow in $VBoxContainer4/ScrollContainer/VBoxContainer.get_children():
		#productRow.set_meta("price", 0)
		$VBoxContainer4/TotalContainer/TotalPrice.value += int(productRow.get_node("VBoxContainer/HBoxContainer/SpinBox").value) * int(productRow.get_meta("price"))
		
func removeFromCartPushed(rowToRemove):
	$VBoxContainer4/ScrollContainer/VBoxContainer.remove_child(rowToRemove)
	$VBoxContainer4/TotalContainer/TotalPrice.value = 0
	for productRow in $VBoxContainer4/ScrollContainer/VBoxContainer.get_children():
		#productRow.set_meta("price", 0)
		$VBoxContainer4/TotalContainer/TotalPrice.value += int(productRow.get_node("VBoxContainer/HBoxContainer/SpinBox").value) * int(productRow.get_meta("price"))

# when the checkout button is pressed
func _on_checkout_button_pressed():
	# get the current number of orders
	database_interface_ref.handleQuery("SELECT COUNT(*) FROM [ORDER]")
	var orderID = int((get_parent().currentData[0][0])) + 1
	print("orderID is ", orderID)
	
	# insert row into ORDER table
	database_interface_ref.handleNonQuery(str("INSERT INTO [ORDER]
	VALUES ( '", orderID,  "','" , get_parent().currentUser, "','", 
	Time.get_date_string_from_system(), "','", str($VBoxContainer4/TotalContainer/TotalPrice.value),
	"')"))
	
	# for each item in the cart, insert a record into ORDER ITEM
	for product in $VBoxContainer4/ScrollContainer/VBoxContainer.get_children():
		database_interface_ref.handleNonQuery(str("INSERT INTO [ORDER ITEM] 
		VALUES (", int(orderID), ",", int(product.get_meta("productId")), ",",
		int(product.get_node("VBoxContainer/HBoxContainer/SpinBox").value), ")"))
		
	


func _on_account_button_pressed():
	var newAccountWindow = load("res://CustomerInterface/AccountScreen.tscn").instantiate()
	newAccountWindow.position = get_viewport_rect().size / 2 - (Vector2(newAccountWindow.size) / 2)
	database_interface_ref.handleQuery(str("SELECT CustomerNumber, CustomerName, CustomerPhoneNum, CustomerAddress FROM CUSTOMER WHERE CustomerNumber = ", get_parent().currentUser))
	
	newAccountWindow.get_node("VBoxContainer/ID").text = get_parent().currentData[0][0]
	newAccountWindow.get_node("VBoxContainer/Name").text = get_parent().currentData[0][1]
	newAccountWindow.get_node("VBoxContainer/PhoneNumber").text = get_parent().currentData[0][2]
	newAccountWindow.get_node("VBoxContainer/Address").text = get_parent().currentData[0][3]
	
	add_child(newAccountWindow)


# FIXME: Log out button is not working
func _on_button_toggled(button_pressed):
	get_parent().logoutButtonPressed()
	self.queue_free()
	
