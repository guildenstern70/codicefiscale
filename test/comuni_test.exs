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
    assert howmany == 8093
  end
  
  
end
