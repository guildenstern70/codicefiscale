#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule CodicefiscaleTest do
  use ExUnit.Case
  doctest Codicefiscale

  test "Normal three consonants" do
    assert Codicefiscale.get_first_consonants("Saltarin") == "SLT"
  end

  test "Normal two consonants" do
    assert Codicefiscale.get_first_consonants("Bo") == "BOX"
  end

  test "Normal one consonant" do
    assert Codicefiscale.get_first_consonants("A") == "AXX"
  end
end
