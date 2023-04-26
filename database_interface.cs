using Godot;
using System;
using Microsoft.Data.SqlClient;
using System.Data;
using Godot.NativeInterop;
using System.Collections.Generic;

public partial class database_interface : Node
{
	SqlConnection conn;
	SqlCommand currentSqlCommand;
	SqlDataReader currentSqlDataReader;
	TextEdit printingGrounds;
	

	public override void _Ready()
	{
		printingGrounds = GetTree().Root.GetNode<TextEdit>("Main/TextEdit");
	}

	public void configureConnection(string connectionStringInput)
	{
		conn = new SqlConnection(connectionStringInput);
		conn.Open();
	}

	public void closeConnection()
	{
		conn.Close();
	}

	public void handleQuery(string queryString)
	{
		conn.Close();
		conn.Open();
		currentSqlCommand = conn.CreateCommand();
		currentSqlCommand.CommandText = queryString;
		currentSqlDataReader = currentSqlCommand.ExecuteReader();
		
		Godot.Variant matrix = new Godot.Collections.Array<string>();
		while(currentSqlDataReader.Read())
		{
			Godot.Variant row = new Godot.Collections.Array();
			for (int i = 0; i < currentSqlDataReader.FieldCount; i++)
			{
				((Godot.Collections.Array)row).Add(currentSqlDataReader[i].ToString());
			}
			((Godot.Collections.Array)matrix).Add(row);
			GetTree().Root.GetNode<Node2D>("Main").Set("currentData", matrix);
		}
	}
}
