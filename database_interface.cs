using Godot;
using System;
using Microsoft.Data.SqlClient;
using System.Data;
using Godot.NativeInterop;
using System.Collections.Generic;

public partial class database_interface : Node
{
	static string connectionString = "Data Source=SILVER;Initial Catalog=BankDB;Integrated Security=True;TrustServerCertificate=True";
	SqlConnection conn = new SqlConnection(connectionString);
	SqlCommand currentSqlCommand;
	SqlDataReader currentSqlDataReader;
	TextEdit printingGrounds;
	

	public override void _Ready()
	{
		conn.Open();
		currentSqlCommand = conn.CreateCommand();
		printingGrounds = GetTree().Root.GetNode<TextEdit>("Main/TextEdit");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{ }

	public void handleQuery(string queryString)
	{
		currentSqlCommand.CommandText = queryString;
		currentSqlDataReader = currentSqlCommand.ExecuteReader();
		
		currentSqlDataReader.Read();
		Godot.Variant matrix = new Godot.Collections.Array<string>();
		foreach (IDataRecord record in currentSqlDataReader)
		{
			Godot.Variant row = new Godot.Collections.Array();
			for (int i = 0; i < record.FieldCount; i++)
			{
				((Godot.Collections.Array)row).Add(record[i].ToString());
			}
			((Godot.Collections.Array)matrix).Add(row);
			GetTree().Root.GetNode<Node2D>("Main").Set("currentData", matrix);
		}
	}
}
