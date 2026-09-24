#
# Codice Fiscale in Elixir
# (C) 2026 Alessio Saltarin <alessiosaltarin@gmail.com>
# MIT License
#

defmodule MainTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "parse_birth_date/1" do
    test "parses ISO date YYYY-MM-DD" do
      assert Main.parse_birth_date("1975-03-23") == {:ok, ~D[1975-03-23]}
    end

    test "parses Italian date DD/MM/YYYY" do
      assert Main.parse_birth_date("23/03/1975") == {:ok, ~D[1975-03-23]}
    end

    test "parses Italian date DD-MM-YYYY" do
      assert Main.parse_birth_date("23-03-1975") == {:ok, ~D[1975-03-23]}
    end

    test "parses date with slashes YYYY/MM/DD" do
      assert Main.parse_birth_date("1975/03/23") == {:ok, ~D[1975-03-23]}
    end

    test "handles leading/trailing spaces" do
      assert Main.parse_birth_date("  1975-03-23  ") == {:ok, ~D[1975-03-23]}
    end

    test "returns error for invalid date format" do
      assert Main.parse_birth_date("invalid-date") == {:error, :invalid_birth_date}
      assert Main.parse_birth_date("19750323") == {:error, :invalid_birth_date}
      assert Main.parse_birth_date("") == {:error, :invalid_birth_date}
    end

    test "returns error for non-existent date" do
      assert Main.parse_birth_date("1975-02-30") == {:error, :invalid_birth_date}
      assert Main.parse_birth_date("31/04/1990") == {:error, :invalid_birth_date}
    end
  end

  describe "parse_gender/1" do
    test "parses male values" do
      assert Main.parse_gender("M") == {:ok, :male}
      assert Main.parse_gender("m") == {:ok, :male}
      assert Main.parse_gender("Male") == {:ok, :male}
      assert Main.parse_gender("maschio") == {:ok, :male}
    end

    test "parses female values" do
      assert Main.parse_gender("F") == {:ok, :female}
      assert Main.parse_gender("f") == {:ok, :female}
      assert Main.parse_gender("Female") == {:ok, :female}
      assert Main.parse_gender("femmina") == {:ok, :female}
    end

    test "returns error for invalid gender" do
      assert Main.parse_gender("X") == {:error, :invalid_gender}
      assert Main.parse_gender("other") == {:error, :invalid_gender}
      assert Main.parse_gender("") == {:error, :invalid_gender}
    end
  end

  describe "validate_input/5" do
    test "returns person map when all inputs are valid" do
      result = Main.validate_input("Lucilla", "Gaspari", "1975-03-23", "Cuneo", "F")

      assert result ==
               {:ok,
                %{
                  name: "Lucilla",
                  surname: "Gaspari",
                  birth_date: ~D[1975-03-23],
                  birth_place: "Cuneo",
                  gender: :female
                }}
    end

    test "handles case-insensitive municipality name" do
      result = Main.validate_input("Mario", "Rossi", "01/01/1980", "milano", "m")

      assert result ==
               {:ok,
                %{
                  name: "Mario",
                  surname: "Rossi",
                  birth_date: ~D[1980-01-01],
                  birth_place: "Milano",
                  gender: :male
                }}
    end

    test "returns error when birth place does not exist" do
      result = Main.validate_input("Mario", "Rossi", "1980-01-01", "Atlantide", "M")

      assert result == {:error, ["Error: Birth place \"Atlantide\" does not exist."]}
    end

    test "returns errors for empty fields" do
      {:error, errors} = Main.validate_input("", "", "", "", "")

      assert "Error: Name cannot be empty." in errors
      assert "Error: Surname cannot be empty." in errors
      assert "Error: Birth date cannot be empty." in errors
      assert "Error: Birth place cannot be empty." in errors
      assert "Error: Gender cannot be empty." in errors
    end

    test "returns error for invalid birth date" do
      {:error, errors} = Main.validate_input("Mario", "Rossi", "not-a-date", "Milano", "M")

      assert Enum.any?(errors, &String.starts_with?(&1, "Error: Invalid birth date"))
    end

    test "returns error for invalid gender" do
      {:error, errors} = Main.validate_input("Mario", "Rossi", "1980-01-01", "Milano", "Unknown")

      assert "Error: Invalid gender \"Unknown\". Expected M or F." in errors
    end
  end

  describe "compute_fiscal_code/0 interactive execution" do
    test "generates fiscal code when all interactive input is valid" do
      input = "Lucilla\nGaspari\n1975-03-23\nCuneo\nF\n"

      output =
        capture_io([input: input], fn ->
          result = Main.compute_fiscal_code()
          assert result == {:ok, "GSPLLL75C63D205T"}
        end)

      assert output =~ "1) NAME: "
      assert output =~ "2) SURNAME: "
      assert output =~ "3) BIRTH DATE (YYYY-MM-DD): "
      assert output =~ "4) BIRTH PLACE: "
      assert output =~ "5) GENDER (M/F): "
      assert output =~ "Person:"
      assert output =~ "> CODICE FISCALE: GSPLLL75C63D205T"
    end

    test "generates fiscal code with Italian date format and lowercase gender" do
      input = "Alessio\nSaltarin\n26/08/1970\nMilano\nm\n"

      output =
        capture_io([input: input], fn ->
          result = Main.compute_fiscal_code()
          assert result == {:ok, "SLTLSS70M26F205X"}
        end)

      assert output =~ "> CODICE FISCALE: SLTLSS70M26F205X"
    end

    test "outputs error and does not generate code when birth place does not exist" do
      input = "Harry\nPotter\n1980-07-31\nHogwarts\nM\n"

      output =
        capture_io([input: input], fn ->
          result = Main.compute_fiscal_code()
          assert {:error, errors} = result
          assert "Error: Birth place \"Hogwarts\" does not exist." in errors
        end)

      assert output =~ "Error: Birth place \"Hogwarts\" does not exist."
      refute output =~ "> CODICE FISCALE:"
    end

    test "outputs error when birth date is invalid" do
      input = "Mario\nRossi\n1980-02-31\nMilano\nM\n"

      output =
        capture_io([input: input], fn ->
          result = Main.compute_fiscal_code()
          assert {:error, _errors} = result
        end)

      assert output =~ "Error: Invalid birth date"
      refute output =~ "> CODICE FISCALE:"
    end
  end
end
