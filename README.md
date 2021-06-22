# ExcoverallsLinter

Simple mix task for checking coverage per file and finding uncovered consecutive lines

## Usage

## mix.exs

Add parameters:

- `test_coverage: [tool: ExCoveralls]`
- `preferred_cli_env: ["coveralls.json": :test]` for skipping `MIX_ENV=test` when executing mix task

```elixir
def project do
  [
    test_coverage: [tool: ExCoveralls],
    preferred_cli_env: ["coveralls.json": :test]
  ]
end

defp deps do
  [
    {:excoveralls_linter, "~> 0.2.1", only: :test}
  ]
end
```

## Running task

```
mix coveralls.lint --help
```

```
mix coveralls.lint --required-project-coverage=0.9 --missed-lines-threshold=5 --required-file-coverage=0.8
```



