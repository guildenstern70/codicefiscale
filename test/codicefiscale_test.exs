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
    assert Codicefiscale.get_surname_consonants("Bo") == "BXO"
  end

  test "Normal two consonants name" do
    assert Codicefiscale.get_name_consonants("Mino") == "MNI"
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
  
  test "Even Or Odds 1" do
    partial_code = "SLTLSS70M26F205"
    evens = Codicefiscale.get_even_or_odd_chars(partial_code, :even)
    odds = Codicefiscale.get_even_or_odd_chars(partial_code, :odd)
    assert odds == [ "S", "T", "S", "7", "M", "6", "2", "5" ]
    assert evens == [ "L", "L", "S", "0", "2", "F", "0"]
  end
  
  test "Even Or Odds 2" do
    partial_code = "GSPLLL75C63D205"
    evens = Codicefiscale.get_even_or_odd_chars(partial_code, :even)
    odds = Codicefiscale.get_even_or_odd_chars(partial_code, :odd)
    assert odds == [ "G", "P", "L", "7", "C", "3", "2", "5" ]
    assert evens == [ "S", "L", "L", "5", "6", "D", "0"]
  end
  
  test "Control Code Sum #1" do
    partial_code = "GSPLLL75C63D205"
    evens = Codicefiscale.get_even_or_odd_chars(partial_code, :even)
    odds = Codicefiscale.get_even_or_odd_chars(partial_code, :odd)
    even_values = Enum.map(evens, &Codicefiscale.get_control_code_even/1)
    odd_values = Enum.map(odds, &Codicefiscale.get_control_code_odd/1)
    even_value = Enum.sum(even_values)
    odd_value = Enum.sum(odd_values)
    remainder = rem(even_value + odd_value, 26)
    assert rem(remainder, 26) == 19
  end
  
  test "Control Code Sum #2" do
    partial_code = "RRRTTT89B19X190"
    evens = Codicefiscale.get_even_or_odd_chars(partial_code, :even)
    odds = Codicefiscale.get_even_or_odd_chars(partial_code, :odd)
    even_values = Enum.map(evens, &Codicefiscale.get_control_code_even/1)
    odd_values = Enum.map(odds, &Codicefiscale.get_control_code_odd/1)
    even_value = Enum.sum(even_values)
    odd_value = Enum.sum(odd_values)
    assert rem(even_value + odd_value, 26) == 12
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
    assert Codicefiscale.compute(person) == "SLTLSS70M26F205X"
  end  
  
  test "Partial Code Lucilla" do
    # Define a person as an Elixir map
    person = %{
      name: "Lucilla",
      surname: "Gaspari",
      birth_date: ~D[1975-03-23],
      birth_place: "Cuneo",
      gender: :female
    }
    assert Codicefiscale.compute(person) == "GSPLLL75C63D205T"
  end

  test "Fiscal Code Mino" do
    person = %{
      name: "Mino",
      surname: "Santanastasio",
      birth_date: ~D[1988-12-28],
      birth_place: "Ceresole Reale",
      gender: :male
    }
    assert Codicefiscale.compute(person) == "SNTMNI88T28C505N"
  end  
    
  test "Control Code" do
    assert Codicefiscale.get_control_code("SLTLSS70M26F205") == "X"
  end
  
end
