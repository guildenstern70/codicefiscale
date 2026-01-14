#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule Codicefiscale do
  @moduledoc """
  Compute the Italian Codice Fiscale (CF) number.
  """
  
  defp check_required_fields(person) do
    required_keys = [:name, :surname, :birth_date]
    Enum.all?(required_keys, &Map.has_key?(person, &1)) # => true
  end
  
  
  def compute(person) do
    
    if !check_required_fields(person) do
      raise ArgumentError, message: "Missing required fields"
    end
    
    first_three =
      person.surname
      |> get_first_consonants()

    second_three =
      person.name
      |> get_first_consonants()
      
    year = get_year(person.birth_date)
    month = get_month(person.birth_date)
    date = get_day(person.birth_date, person.gender)
      
    first_three <> second_three <> year <> month <> date
  end
  
  def get_first_consonants(word) do
    cond do
      String.length(word) == 1 -> get_first_consonants_one(word)
      String.length(word) == 2 -> get_first_consonants_two(word)
      String.length(word) > 2 -> get_first_consonants_std(word, 3)
    end
  end
  
  def get_year(birthdate) do
    year = birthdate.year
    year |> Integer.to_string() |> String.slice(2..3)
  end
  
  def get_month(birthdate) do
    month = birthdate.month
    cond do
      month == 1 -> "A"
      month == 2 -> "B"
      month == 3 -> "C"
      month == 4 -> "D"
      month == 5 -> "E"
      month == 6 -> "H"
      month == 7 -> "L"
      month == 8 -> "M"
      month == 9 -> "P"
      month == 10 -> "R"
      month == 11 -> "S"
      month == 12 -> "T"
    end
  end
  
  def get_day(birthdate, gender) do
    day = cond do
      gender == :male -> birthdate.day
      gender == :female -> birthdate.day + 40
    end
    cond do
      day < 10 -> "0" <> Integer.to_string(day)
      day >= 10 -> Integer.to_string(day)
    end
  end
  
  defp get_first_consonants_one(word) do
    upword =word
    |> String.upcase()
    upword <> "XX"
  end
  
  defp get_first_consonants_two(word) do
    upword =word
    |> String.upcase()
    upword <> "X"
  end
  
  defp get_first_consonants_std(word, howmany) do
    word
    |> String.replace(" ", "")
    |> String.upcase()
    |> String.graphemes()
    |> Enum.filter(
      &(&1 in [
          "B",
          "C",
          "D",
          "F",
          "G",
          "H",
          "J",
          "K",
          "L",
          "M",
          "N",
          "P",
          "Q",
          "R",
          "S",
          "T",
          "V",
          "W",
          "X",
          "Y",
          "Z"
        ])
    )
    |> Enum.take(howmany)
    |> Enum.join()
  end
  
  
end
