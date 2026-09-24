#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule Main do
  use Application

  @version Mix.Project.config()[:version]

  def print_help() do
    IO.puts("Usage: mix run -- [option]")
    IO.puts("Options:")
    IO.puts("  help       Print this help message")
    IO.puts("  version    Print the version")
    IO.puts("  createdb   Create the 'comuni' database")
  end

  def print_version() do
    IO.puts("Codice Fiscale v.#{@version}")
  end

  def compute_fiscal_code() do
    name = prompt_input("1) NAME: ")
    surname = prompt_input("2) SURNAME: ")
    birth_date_str = prompt_input("3) BIRTH DATE (YYYY-MM-DD): ")
    birth_place_str = prompt_input("4) BIRTH PLACE: ")
    gender_str = prompt_input("5) GENDER (M/F): ")

    case validate_input(name, surname, birth_date_str, birth_place_str, gender_str) do
      {:ok, person} ->
        IO.puts("\nPerson:")
        IO.inspect(person)

        fiscal_code = Codicefiscale.compute(person)
        IO.puts("> CODICE FISCALE: " <> fiscal_code)
        {:ok, fiscal_code}

      {:error, errors} ->
        IO.puts("")
        Enum.each(errors, &IO.puts/1)
        {:error, errors}
    end
  end

  def validate_input(name, surname, birth_date_str, birth_place_str, gender_str) do
    errors = []

    {name_val, errors} =
      case String.trim(name || "") do
        "" -> {nil, errors ++ ["Error: Name cannot be empty."]}
        n -> {n, errors}
      end

    {surname_val, errors} =
      case String.trim(surname || "") do
        "" -> {nil, errors ++ ["Error: Surname cannot be empty."]}
        s -> {s, errors}
      end

    {birth_date_val, errors} =
      case String.trim(birth_date_str || "") do
        "" ->
          {nil, errors ++ ["Error: Birth date cannot be empty."]}

        str ->
          case parse_birth_date(str) do
            {:ok, date} ->
              {date, errors}

            {:error, _} ->
              {nil,
               errors ++
                 [
                   "Error: Invalid birth date \"#{str}\". Expected format: YYYY-MM-DD or DD/MM/YYYY."
                 ]}
          end
      end

    {birth_place_val, errors} =
      case String.trim(birth_place_str || "") do
        "" ->
          {nil, errors ++ ["Error: Birth place cannot be empty."]}

        str ->
          case Comuni.find_comune(str) do
            nil ->
              {nil, errors ++ ["Error: Birth place \"#{str}\" does not exist."]}

            row ->
              {Enum.at(row, 1), errors}
          end
      end

    {gender_val, errors} =
      case String.trim(gender_str || "") do
        "" ->
          {nil, errors ++ ["Error: Gender cannot be empty."]}

        str ->
          case parse_gender(str) do
            {:ok, gender} ->
              {gender, errors}

            {:error, _} ->
              {nil, errors ++ ["Error: Invalid gender \"#{str}\". Expected M or F."]}
          end
      end

    if errors == [] do
      {:ok,
       %{
         name: name_val,
         surname: surname_val,
         birth_date: birth_date_val,
         birth_place: birth_place_val,
         gender: gender_val
       }}
    else
      {:error, errors}
    end
  end

  def parse_birth_date(str) when is_binary(str) do
    trimmed = String.trim(str)

    with {:ok, [y, m, d]} <- extract_date_parts(trimmed),
         {:ok, date} <- Date.new(y, m, d) do
      {:ok, date}
    else
      _ -> {:error, :invalid_birth_date}
    end
  end

  defp extract_date_parts(str) do
    cond do
      # YYYY-MM-DD or YYYY/MM/DD
      match = Regex.run(~r/^(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})$/, str) ->
        [_, y, m, d] = match
        {:ok, [String.to_integer(y), String.to_integer(m), String.to_integer(d)]}

      # DD/MM/YYYY or DD-MM-YYYY
      match = Regex.run(~r/^(\d{1,2})[-\/](\d{1,2})[-\/](\d{4})$/, str) ->
        [_, d, m, y] = match
        {:ok, [String.to_integer(y), String.to_integer(m), String.to_integer(d)]}

      true ->
        {:error, :invalid_format}
    end
  end

  def parse_gender(str) when is_binary(str) do
    case String.trim(str) |> String.upcase() do
      g when g in ["M", "MALE", "MASCHIO"] -> {:ok, :male}
      g when g in ["F", "FEMALE", "FEMMINA"] -> {:ok, :female}
      _ -> {:error, :invalid_gender}
    end
  end

  defp prompt_input(prompt) do
    case IO.gets(prompt) do
      :eof -> ""
      {:error, _} -> ""
      val when is_binary(val) -> String.trim(val)
    end
  end

  def build_comuni_db() do
    IO.puts("Building 'comuni' database...")
    Comuni.build_db()
  end

  def start(_type, _args) do
    IO.puts("Codice Fiscale v.#{@version}")
    IO.puts("Running in " <> File.cwd!())
    arguments = System.argv()

    cond do
      Code.ensure_loaded?(Mix) and Mix.env() == :test -> :ok
      arguments == [] -> compute_fiscal_code()
      arguments in [["help"], ["--help"], ["-h"]] -> print_help()
      arguments in [["version"], ["--version"], ["-v"]] -> print_version()
      arguments in [["createdb"], ["builddb"]] -> build_comuni_db()
      true -> :ok
    end

    # List all child processes to be supervised
    children = []

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: A.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
