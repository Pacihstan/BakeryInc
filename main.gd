extends Node2D
var currentData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$database_interface.configureConnection("Data Source=SILVER;Initial Catalog=BankDB;Integrated Security=True;TrustServerCertificate=True")
	$database_interface.handleQuery("SELECT * FROM Accounts")
	$database_interface.closeConnection()
	$TextEdit.text += str(currentData)
