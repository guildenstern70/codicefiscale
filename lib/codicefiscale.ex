#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule Codicefiscale do
  @moduledoc """
  Compute the Italian Codice Fiscale (CF) number.
  """
  def compute(person) do
    first_three =
      person.surname
      |> get_first_consonants()

    second_three =
      person.name
      |> get_first_consonants()
      
    first_three <> second_three
  end
  
  def get_first_consonants(word) do
    cond do
      String.length(word) == 1 -> get_first_consonants_one(word)
      String.length(word) == 2 -> get_first_consonants_two(word)
      String.length(word) > 2 -> get_first_consonants_std(word, 3)
    end
  end
  
  def get_first_consonants_one(word) do
    upword =word
    |> String.upcase()
    upword <> "XX"
  end
  
  def get_first_consonants_two(word) do
    upword =word
    |> String.upcase()
    upword <> "X"
  end

  def get_first_consonants_std(word, howmany) do
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
