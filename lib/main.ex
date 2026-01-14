#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule Main do
  use Application

  def start(_type, _args) do
    IO.puts "Codice Fiscale v.0.1.0"
    
    # Define a person as an Elixir map
    person = %{
      name: "Alessio",
      surname: "Saltarin",
      birth_date: ~D[1970-08-26],
      birth_place: "Milano",
      gender: :male
    }
    
    first_three = person |> Codicefiscale.compute()
    IO.puts(first_three)
    
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: A.Worker.start_link(arg)
      # {A.Worker, arg},
    ]
  
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: A.Supervisor]
    Supervisor.start_link(children, opts)
    
  end
end