#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule ComuniTest do
  use ExUnit.Case
  doctest Comuni
  
  test "Can load comuni from text file" do
    { comuni, howmany } = Comuni.comuni_from_csv()
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
    
end
