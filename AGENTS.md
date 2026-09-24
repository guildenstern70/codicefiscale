# AGENT.md

Guidelines and reference for AI agents working on the **Codicefiscale** codebase.

---

## 1. Project Overview

**Codicefiscale** is an Elixir library and CLI application that calculates the Italian Fiscal Code (*Codice Fiscale*, CF) — a 16-character alphanumeric identifier assigned to individuals in Italy.

- **Language / Runtime:** Elixir (`~> 1.19`), Erlang/OTP
- **Build Tool:** Mix
- **Database:** SQLite via [`exqlite`](https://hex.pm/packages/exqlite) (`~> 0.27`)
- **Test Framework:** ExUnit

---

## 2. Repository Layout

```text
codicefiscale/
├── comunidb/
│   ├── listacomuni.csv       # Source dataset of Italian municipalities (ISTAT, names, codes)
│   └── comuni.db             # Generated SQLite database (gitignored; must be created locally)
├── lib/
│   ├── codicefiscale.ex      # Core algorithm for generating the 16-character fiscal code
│   ├── comuni.ex             # SQLite database management and municipality lookups
│   └── main.ex               # Application entrypoint (CLI routing & supervision tree)
├── test/
│   ├── codicefiscale_test.exs# Unit tests for fiscal code rules and computation
│   ├── comuni_test.exs       # Unit tests for CSV ingestion and database queries
│   └── test_helper.exs       # ExUnit test helper
├── mix.exs                   # Project configuration, dependencies, application definition
└── README.md                 # User-facing documentation
```

---

## 3. Critical Prerequisite: Database Initialization

> [!IMPORTANT]
> The SQLite database file (`comunidb/comuni.db`) is **not** committed to version control.
> **You must initialize the database before running the program or executing tests.**
> Failing to initialize the database will cause tests and computations to fail with:
> `{:error, "no such table: comuni"}`.

### Command to Create Database

```bash
mix run -- createdb
```

*(Note: `mix run -- builddb` is supported as a backward-compatible alias).*

This command parses `comunidb/listacomuni.csv` and populates `comunidb/comuni.db` with the `comuni` table schema:
- `id`: ISTAT code (TEXT PRIMARY KEY)
- `comune`: Municipality name (TEXT)
- `provincia`: Province abbreviation (TEXT)
- `regione`: Region name (TEXT)
- `prefisso`: Area dial code (TEXT)
- `cap`: Postal code (TEXT)
- `codice`: 4-character cadastral code used in the fiscal code (TEXT, e.g. `F205` for Milano)

---

## 4. Common Agent Commands

### Install Dependencies
```bash
mix deps.get
```

### Compile Code
```bash
mix compile
```

### Initialize Database
```bash
mix run -- createdb
```

### Run Tests
```bash
mix test
```

### Run Application (CLI)
```bash
mix run               # Executes sample calculation in Main.compute_fiscal_code/0
mix run -- help       # Displays CLI options
mix run -- version    # Displays version
mix run -- createdb   # Generates SQLite database
```

### Code Formatting
```bash
mix format
```

---

## 5. Domain Logic & Fiscal Code Specification

The Italian fiscal code consists of 16 characters calculated as follows:

| Position | Characters | Source | Calculation Rule |
| :--- | :--- | :--- | :--- |
| 1–3 | 3 letters | Surname | First 3 consonants. If < 3 consonants, vowels follow. If < 3 letters total, padded with `X`. |
| 4–6 | 3 letters | Name | If ≥ 4 consonants: 1st, 3rd, and 4th consonants. If 3 consonants: all 3. If < 3 consonants: consonants then vowels, padded with `X`. |
| 7–8 | 2 digits | Year of Birth | Last two digits of the birth year (e.g. 1975 -> `75`). |
| 9 | 1 letter | Month of Birth | Letter mapping: `A` (Jan), `B` (Feb), `C` (Mar), `D` (Apr), `E` (May), `H` (Jun), `L` (Jul), `M` (Aug), `P` (Sep), `R` (Oct), `S` (Nov), `T` (Dec). |
| 10–11 | 2 digits | Day & Gender | Males: day of month (`01`–`31`). Females: day of month + 40 (`41`–`71`). |
| 12–15 | 4 chars | Birthplace | 4-character cadastral code (*codice catastale*) from `comunidb/comuni.db` (e.g. `F205` for Milano, `D205` for Cuneo). |
| 16 | 1 letter | Check Character | Algorithmic checksum: odd positions (1st, 3rd, ...) and even positions (2nd, 4th, ...) map to specific weights. The sum modulo 26 yields a letter `A`–`Z`. |

### Person Data Structure
The person map passed to `Codicefiscale.compute/1` expects:
```elixir
%{
  name: "Lucilla",
  surname: "Gaspari",
  birth_date: ~D[1975-03-23],
  birth_place: "Cuneo",
  gender: :female # :male or :female
}
```

---

## 6. Environment & Sandboxing Notes

- In restricted sandbox environments where `~/.mix` is outside sandbox permissions, running `mix` commands that invoke Hex/Rebar might require elevated permissions / sandbox bypass.
- When adding new dependencies to `mix.exs`, always verify `mix deps.get` and lockfile updates in `mix.lock`.
