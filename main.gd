extends Node2D
var currentData

# Called when the node enters the scene tree for the first time.
func _ready():
	$database_interface.configureConnection("Data Source=SILVER;Initial Catalog=BankDB;Integrated Security=True;TrustServerCertificate=True")
	$database_interface.handleQuery("SELECT * FROM Accounts")
	$database_interface.closeConnection()
	await get_tree().process_frame
	$TextEdit.text += str(currentData)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	