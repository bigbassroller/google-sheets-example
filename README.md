# Elixir - Getting Started with Google Sheets API and Service Accounts


## Create app

1. `mix new google_sheets_example`
2. `cd google_sheets_example && mix ecto.create`
3. `git init && git add --all && git commit -m "initial commit"`


## Create Credentials 

1. Go to [https://console.developers.google.com/apis/credentials](https://console.developers.google.com/apis/credentials) > Create credentials > Service account key
2. Add the downloaded credentials directory path to an environment variable:
`export GOOGLE_APPLICATION_CREDENTIALS=service_account.json`


### Add dependencies
To use Google Sheets API V4 all we need are two dependencies:

- [google_api_sheets](https://hex.pm/packages/google_api_sheets)
- [goth](https://hex.pm/packages/goth)

Lets add them to our mix.exs file:

***mix.exs***
```elixir
...
{:goth, "~> 1.1"}
{:google_api_sheets, "~> 0.11.0"}
...
```

Next run the mix deps get command:

`mix deps.get`

We are now ready to start making API calls to Google API Sheets API. The first step is sometimes the most scary, authenticating requests 😱

## Create a connection

Maybe its from having to deal with Node.js and client side JavaScript at my day job working with Google Sheets, but getting started with Elixir is way simplier and easier.

The flow goes like this: we use the Goth library to make token request with auth spreadsheet scope. For more details on sheets authoring, see this [page](https://developers.google.com/sheets/api/guides/authorizing). Remember the `export GOOGLE_APPLICATION_CREDENTIALS=service_account.json` we did when creating the "Create Credentials" step? Goth library uses its industrial magic to use those credentials as the API key when making the requests. With the token recieved, we use it with the [GoogleApi.Sheets.V4.Connection.new](https://hexdocs.pm/google_api_sheets/GoogleApi.Sheets.V4.Connection.html#new/0) function with the token's token in its parameters. That is it!

It looks like this:
```elixir
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
    conn = GoogleApi.Sheets.V4.Connection.new(token.token)
```

[GoogleApi.Sheets.V4.Connection - Summary](https://hexdocs.pm/google_api_sheets/GoogleApi.Sheets.V4.Connection.html#summary)


### What is a telsa client?

While debugging, you might see "Tesla" and be like WTF, what Elon doing in my code? Tesla is a hex package that Elixir Google API uses under the hood to build API clients using middlewares. See the [Tesla API Reference](https://hexdocs.pm/tesla/api-reference.html) for details if needed.

OK see we got the auth out of the way, now we can use it to do CRUD operations on Google Sheets.


## Get Spreadsheet
To get a spreadsheets basic info, we can use (sheets_spreadsheets_get)[https://hexdocs.pm/google_api_sheets/GoogleApi.Sheets.V4.Api.Spreadsheets.html] along with a token request and connection. 


```elixir
  def sheet_info(spreadsheet_id) do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
    conn = GoogleApi.Sheets.V4.Connection.new(token.token)

    {:ok, response} = GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_get(conn, spreadsheet_id)
  end
```


## List Majors
Taken from the classic (if you have been working with Google Sheets API), [Node.js Quickstart](https://developers.google.com/sheets/api/quickstart/nodejs). 

```elixir
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
      IO.inspect(name) 
      IO.inspect(major) 
    end)
   
  end
```



https://hexdocs.pm/google_api_sheets/GoogleApi.Sheets.V4.Api.Spreadsheets.html#sheets_spreadsheets_values_get/5

## Create Sheet

```elixir
...
  def create_sheet() do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets")
    conn = GoogleApi.Sheets.V4.Connection.new(token.token)
    {:ok, response} = GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_create(conn)
  end
...
```

https://hexdocs.pm/google_api_sheets/GoogleApi.Sheets.V4.Api.Spreadsheets.html#sheets_spreadsheets_create/3

### A note on service accounts and creating a new sheet

A service account uses its own unique email address. Therefor you will have to add your actual email account as a user to a spreadsheet created with a service account. See this [Stack Overflow](https://stackoverflow.com/questions/37967937/google-sheets-api-v4-create-sheet-and-invite-users) article for workaround solution


## Running the code

To run the code, we can simply go into the elixir command line prompt, `iex` and then call our functions:


`iex -S mix`


`GoogleSheetsExample.list_majors` 


## Thats all for now

This is enough to get started. Improvements would be extracting the token and conn calls to its own function, OAuth2.0 variation and build a simple API that does Read, Append, Update, Create operations. Example of Read, Append, Update, Create is this article, [node-js-using-google-sheets-api-with-oauth-2](https://www.woolha.com/tutorials/node-js-using-google-sheets-api-with-oauth-2).

Cheers and happy coding!









