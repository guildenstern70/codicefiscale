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
  
  test "Birth year" do
    assert Codicefiscale.get_year(Date.new!(1990, 1, 1)) == "90"
  end
  
  test "Birth month" do
    assert Codicefiscale.get_month(Date.new!(1970, 8, 26)) == "M"
  end
  
  test "Birth day" do
    assert Codicefiscale.get_day(Date.new!(1970, 8, 26), :male) == "26"
    assert Codicefiscale.get_day(Date.new!(1970, 8, 26), :female) == "66"
  end
  
end
