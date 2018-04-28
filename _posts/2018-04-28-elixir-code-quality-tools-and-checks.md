---
layout: post
title: Elixir code quality tools and checks
crosspost_to_medium: true
tags: [programming, elixir, code, quality]
---

Elixir progamming language has a great and huge community and ecosystem.
As for now, we can easily do static code analysis and code quality checks by using
plenty of standard or external tools. This allow us to write robust solid Elixir code
in uniform way according to the [style guide](https://github.com/christopheradams/elixir_style_guide) .

Let's start with the most popular tools and solutions: 

## mix compile --warnings-as-errors

The first and most simple check that could be existed.
Elixir compiler is pretty smart and can easily detect harsh mistakes like unused
variables or mismatched module names. It is pretty friendly though, because
compiler just warns you about these problems, but does not stop compilation.
For some reasons, especially if we are running the CI, we want to make it more obvious and stop any further checks.
This can be achieved by running `mix compile` task with according option:

```elixir
mix compile --warnings-as-errors
```

## mix format --check-formatted

Elixir 1.6 introduced yet another one useful tool - the formatter. After that we
can keep our codebase consistent in one uniform code style without any contradictions.
In the real life not everyone use the formatter and we need to force this option
by running `mix format` task with the `--check-formatted` option during CI.

```elixir
mix format --check-formatted
```

## Credo

[Credo][https://github.com/rrrene/credo] is a static analysis code tool for Elixir.
It's more just usual code checker - it can teach you how to write your code better,
show refactoring possibilities and inconsistencies in naming.

In order to start to use Credo, you need to add it to your `mix.exs` deps:

```elixir
{:credo, "~> 0.9.1", only: ~w(dev test)a, runtime: false}
```

You can force your own code style for your team by using Credo configuration file.
For example, we can create `config/.credo.exs` file with this content:

```elixir
%{
  #
  # You can have as many configs as you like in the `configs:` field.
  configs: [
    %{
      #
      # Run any exec using `mix credo -C <name>`. If no exec name is given
      # "default" is used.
      name: "default",
      #
      # These are the files included in the analysis:
      files: %{
        #
        # You can give explicit globs or simply directories.
        # In the latter case `**/*.{ex,exs}` will be used.
        excluded: [~r"/_build/", ~r"/deps/", ~r"/priv/"]
      },
      #
      # If you create your own checks, you must specify the source files for
      # them here, so they can be loaded by Credo before running the analysis.
      requires: [],
      #
      # Credo automatically checks for updates, like e.g. Hex does.
      # You can disable this behaviour below:
      check_for_updates: true,
      #
      # If you want to enforce a style guide and need a more traditional linting
      # experience, you can change `strict` to `true` below:
      strict: true,
      #
      # If you want to use uncolored output by default, you can change `color`
      # to `false` below:
      color: true,
      #
      # You can customize the parameters of any check by adding a second element
      # to the tuple.
      #
      # To disable a check put `false` as second element:
      #
      #     {Credo.Check.Design.DuplicatedCode, false}
      #
      checks: [
        {Credo.Check.Readability.Specs, priority: :low},
        {Credo.Check.Design.TagTODO, exit_status: 0},
        {Credo.Check.Design.TagFIXME, exit_status: 0},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 100}
      ]
    }
  ]
}
```

## Xref

## Sobelow

## Dialyzer


## Conclusion

What's next? 

Happy hacking!
