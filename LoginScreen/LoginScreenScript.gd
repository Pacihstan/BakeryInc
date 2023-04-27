extends Window

@onready var database_interface_ref = get_node("../database_interface")
@onready var root_ref = get_node("../")
var userType
var signUpControl
var MainLoginControlInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	MainLoginControlInstance = load("res://LoginScreen/LoginScreenControl.tscn").instantiate()
	add_child(MainLoginControlInstance)
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onLoginButtonPressed():
	database_interface_ref.handleQuery("SELECT * FROM EMPLOYEE")
	for row in root_ref.currentData:
		if MainLoginControlInstance.get_node("UsernameEntry").text == row[1]: #if login successful
			if row[4] == "False":
				userType = "Employee"
			elif row[4] == "True":
				userType = "Manager"
			root_ref.currentUser = row[0]
			root_ref.userType = userType
			self.queue_free() #allow user to continue to application

	database_interface_ref.handleQuery("SELECT * FROM CUSTOMER")
	for row in root_ref.currentData:
		if MainLoginControlInstance.get_node("UsernameEntry").text == row[1]: #if login successful
			userType = "Customer"
			root_ref.currentUser = row[0]
			root_ref.userType = userType
			self.queue_free() #allow user to continue to application
	
func signUpButtonPressed():
	remove_child(MainLoginControlInstance)
	signUpControl = load("res://LoginScreen/SignUpControl.tscn").instantiate()
	add_child(signUpControl)
	
func signUpCompleted():
	remove_child(signUpControl)
	MainLoginControlInstance = load("res://LoginScreen/LoginScreenControl.tscn").instantiate()
	add_child(MainLoginControlInstance)

func _on_close_requested():
	get_tree().quit()


func _on_tree_exited():
	root_ref.loginComplete(userType)
