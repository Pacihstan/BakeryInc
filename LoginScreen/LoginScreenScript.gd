extends Window

@onready var database_interface_ref = get_node("../database_interface")
@onready var root_ref = get_node("../")
var userType


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_login_button_pressed():
	"""
	database_interface_ref.handleQuery("SELECT * FROM EMPLOYEE")
	print(root_ref.currentData)
	for row in root_ref.currentData:
		if $VBoxContainer/UsernameEntry.text == row[1]: #if login successful
			userType = str(row[4]).replace(" ", "")
			self.queue_free() #allow user to continue to application
	"""
	database_interface_ref.handleQuery("SELECT * FROM CUSTOMER")
	print(root_ref.currentData)
	for row in root_ref.currentData:
		if $VBoxContainer/UsernameEntry.text == row[1]: #if login successful
			userType = "Customer"
			self.queue_free() #allow user to continue to application
	


func _on_close_requested():
	get_tree().quit()


func _on_tree_exited():
	root_ref.loginComplete(userType)
