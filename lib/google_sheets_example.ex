defmodule GoogleSheetsExample do
  @moduledoc """
  GoogleSheetsExample keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def create_sheet() do
  	{:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
  	IO.inspect(token)
  	conn = GoogleApi.Sheets.V4.Connection.new(token.token)
  	IO.inspect(conn)
  	{:ok, response} = GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_create(conn)
  	IO.inspect(response)
  end

  def sheet_info(spreadsheet_id) do
  	{:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
  	IO.inspect(token)
  	conn = GoogleApi.Sheets.V4.Connection.new(token.token)
  	IO.inspect(conn)

  	{:ok, response} = GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_get(conn, spreadsheet_id)
  	IO.inspect(response)
  end

  def list_majors() do
  	{:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
  	conn = GoogleApi.Sheets.V4.Connection.new(token.token)

  	spreadsheet_id = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
  	range = "Class Data!A2:E"

  	{:ok, response} = GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_get(conn, spreadsheet_id, range)
  	values = response.values

	  Enum.map(values, fn row -> 
      name = Enum.fetch(row, 0)
      major = Enum.fetch(row, 4)
      IO.inspect("---------------")
      IO.inspect(List.last(Tuple.to_list(name)), label: "name") 
      IO.inspect(List.last(Tuple.to_list(major)), label: "major") 
    end)

	 
  end



end
