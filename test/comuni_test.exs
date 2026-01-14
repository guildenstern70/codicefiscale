#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule ComuniTest do
  use ExUnit.Case
  doctest Comuni
  
  test "Can load comuni from text file" do
    comuni = Comuni.comuni_from_text_file("comunidb/listacomuni.csv")
    assert length(comuni) == 8093
  end
  
  
end
