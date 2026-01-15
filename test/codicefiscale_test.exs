#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule CodicefiscaleTest do
  use ExUnit.Case
  doctest Codicefiscale

  test "Normal three consonants surname" do
    assert Codicefiscale.get_surname_consonants("Saltarin") == "SLT"
  end

  test "Normal two consonants surname" do
    assert Codicefiscale.get_surname_consonants("Bo") == "BOX"
  end

  test "Normal one consonant surname" do
    assert Codicefiscale.get_surname_consonants("A") == "AXX"
  end
  
  test "Consonants name with len <=3" do
    assert Codicefiscale.get_name_consonants("Alessio") == "LSS"
  end
  
  test "Consonants name with len >3" do
    assert Codicefiscale.get_name_consonants("Lucilla Loretta") == "LLL"
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
  
  test "Partial Code Alessio" do
    # Define a person as an Elixir map
    person = %{
      name: "Alessio",
      surname: "Saltarin",
      birth_date: ~D[1970-08-26],
      birth_place: "Milano",
      gender: :male
    }
    assert Codicefiscale.compute(person) == "SLTLSS70M26F205"
  end  
  
  test "Partial Code Lucilla" do
    # Define a person as an Elixir map
    person = %{
      name: "Lucilla Loretta Libera",
      surname: "Gaspari",
      birth_date: ~D[1975-03-17],
      birth_place: "Cuneo",
      gender: :female
    }
    assert Codicefiscale.compute(person) == "GSPLLL75C57D205"
  end  
  
  test "Control Code" do
    assert Codicefiscale.get_control_code("SLTLSS70M26F205") == "X"
  end
  
end
