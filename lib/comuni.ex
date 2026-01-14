#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule Comuni do

  def create_comuni_table do
    {:ok, conn} = Exqlite.Sqlite3.open("comuni.db")
    {:ok, _error} = Exqlite.Sqlite3.execute(conn, """
    CREATE TABLE IF NOT EXISTS comuni 
      (id INTEGER PRIMARY KEY, 
       comune TEXT, 
       provincia TEXT,
       regione TEXT,
       prefisso TEXT,
       cap TEXT,
       codice TEXT)
    """)
    Exqlite.Sqlite3.close(conn)
  end

  def insert_comune(comune) do
    {:ok, conn} = Exqlite.Sqlite3.open("comuni.db")
    {:ok, _} = Exqlite.Sqlite3.execute(conn, """
    
    INSERT INTO comuni (
    nome, 
    provincia,
    regione,
    prefisso,
    cap,
    codice) VALUES (?, ?, ?, ?, ?, ?)
    
    """, [comune.comune, 
          comune.provincia, 
          comune.regione, 
          comune.prefisso, 
          comune.cap, 
          comune.codice])
    Exqlite.Sqlite3.close(conn)
  end
  
  
  def comune_from_text_line(text) do
    [istat, nome, provincia, regione, prefisso, cap, codice, _abitanti, _link] = String.split(text, ";")
    %{id: istat, comune: nome, provincia: provincia, regione: regione, prefisso: prefisso, cap: cap, codice: codice}
  end
  
  def comuni_from_text_file(file_path) do
    {:ok, file} = File.read(file_path)
    file
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&comune_from_text_line/1)
  end
  
end
