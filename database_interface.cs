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
		currentSqlCommand = conn.CreateCommand(); ;
	}

	public void closeConnection()
	{
		conn.Close();
	}

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
