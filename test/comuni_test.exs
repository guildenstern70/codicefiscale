#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule ComuniTest do
  use ExUnit.Case
  doctest Comuni

  test "Can load comuni from text file" do
    {comuni, howmany} = Comuni.comuni_from_csv()
    assert length(comuni) > 0
    assert howmany == 8092
  end

  test "Can get the attributes of Milano" do
    comune = Comuni.find_comune("Milano")
    [codice | _] = Enum.take(comune, -1)
    [provincia | _] = Enum.take(comune, -5)
    assert codice == "F205"
    assert provincia == "MI"
  end

  test "Milano comune code is F205" do
    assert Comuni.find_comune_code("Milano") == "F205"
  end

  test "Case-insensitive lookup for Milano" do
    assert Comuni.find_comune_code("milano") == "F205"
    assert Comuni.find_comune_code("MILANO") == "F205"
  end

  test "Non-existent comune returns nil" do
    assert Comuni.find_comune("NonExistentCity") == nil
    assert Comuni.find_comune_code("NonExistentCity") == nil
  end

  test "comune_exists? returns true for existing and false for non-existing" do
    assert Comuni.comune_exists?("Milano") == true
    assert Comuni.comune_exists?("milano") == true
    assert Comuni.comune_exists?("NonExistentCity") == false
  end
end
