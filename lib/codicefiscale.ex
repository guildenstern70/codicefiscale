#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule Codicefiscale do
  @moduledoc """
  Compute the Italian Codice Fiscale (CF) number.
  """

  @doc """
  Compute the Codice Fiscale number for a given person.

  ## Examples

      iex> Codicefiscale.compute()

  """
  def compute(person) do
    person.surname 
    |> first_three_letters()
  end
    
  def first_three_letters(name) do
    name
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&(&1 in ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]))
    |> Enum.take(3)
    |> Enum.join()
  end
  
  
  
end
