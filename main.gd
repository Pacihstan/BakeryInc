extends Node2D
var currentData
var currentUser

# Called when the node enters the scene tree for the first time.
func _ready():
	$database_interface.configureConnection("Data Source=SILVER;Initial Catalog=BakeryDatabase;Integrated Security=True;TrustServerCertificate=True")
	$database_interface.handleQuery("SELECT * FROM Employee")
	await get_tree().process_frame
	var loginScreen = load("res://LoginScreen/LoginScreen.tscn").instantiate()
	loginScreen.position = get_viewport_rect().size / 2 - (Vector2(loginScreen.size) / 2)
	add_child(loginScreen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func csharpPrint(printInput):
	print(printInput)

func loginComplete():
	var mainInterface = load("res://CustomerInterface/MainCustomerExperience.tscn").instantiate()
	mainInterface.position = Vector2(get_viewport_rect().size.x / 2, 0)
	add_child(mainInterface)
