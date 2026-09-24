# Codicefiscale

This is an Elixir library and CLI application that calculates the Italian Fiscal Code (*Codice Fiscale*, CF) — a 16-character alphanumeric identifier assigned to individuals in Italy.

## Setup

To run this program you need to set up an Erlang+Elixir environment, as described here:
https://elixir-lang.org/install.html

This program uses the [exqlite](https://hex.pm/packages/exqlite) library to interact with a SQLite database.

### 1. Download Dependencies

```bash
mix deps.get
```

### 2. Initialize the Database

> **Important**: First of all, the SQLite database containing Italian municipalities (*comuni*) and their cadastral codes must be created before running the program or executing tests.

Generate the database (`comunidb/comuni.db`) from `comunidb/listacomuni.csv` using the `createdb` option:

```bash
mix run -- createdb
```

Once executed, you will see:
```text
Building 'comuni' database...
Database created
```

## Running the Program

To run the interactive fiscal code calculation:

```bash
mix run
```

You will be interactively prompted to enter the person's details:
1. **NAME**
2. **SURNAME**
3. **BIRTH DATE** (format: `YYYY-MM-DD` or `DD/MM/YYYY`)
4. **BIRTH PLACE** (Italian municipality name, e.g. `Milano` or `Cuneo`)
5. **GENDER** (`M` or `F`)

The program verifies that all inputs are valid and checks that the birth place exists in the database. If any input is invalid (e.g. municipality does not exist), an error message is displayed.

### Options & Help Menu

Command-line options can be passed to `mix run` after `--`:

```bash
mix run -- [option]
```

Available options:

| Option | Description | Command |
| :--- | :--- | :--- |
| `help` | Print the help menu | `mix run -- help` |
| `version` | Print the application version | `mix run -- version` |
| `createdb` | Create and populate the SQLite database from CSV | `mix run -- createdb` |
| *(none)* | Interactively prompt for parameters and calculate fiscal code | `mix run` |

#### Help Menu Output

Running `mix run -- help` displays:

```text
Usage: mix run -- [option]
Options:
  help       Print this help message
  version    Print the version
  createdb   Create the 'comuni' database
```

## Run Tests

Run the test suite with:

```bash
mix test
```