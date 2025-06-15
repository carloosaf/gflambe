# gflambe

[![Package Version](https://img.shields.io/hexpm/v/gflambe)](https://hex.pm/packages/gflambe)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gflambe/)

Generate flame graphs from Gleam programs, a wrapper for the erlang library [eflambe](https://github.com/Stratus3D/eflambe)

## Installation

```sh
gleam add gflambe
```

## Usage

This library provides two main functions, we will use an example function called
`sum` that takes a list of integers and returns their sum as an example subject 
for the graph.

```gleam
// math.gleam

pub fn sum(list: List(Int)) -> Int {
  list
  |> list.fold(0, fn(acc, item) {
    acc + item
  })
}
```

### `apply`

Takes a function and a list of options and generates a flame graph from 
its execution.

```gleam
import gflambe
import math

pub fn main() {
  options = [
    gflambe.OutputFormat(gflambe.Svg),
  ]

  gflambe.apply(fn() {
    math.sum([1, 2, 3, 4, 5])
  }, options)
}
```

### `capture`

Takes a tuple of modules name, function name and arity, a number of calls to
capture and a list of options and generates a flame graph from its execution.
It waits for the function to be called `number_of_calls_to_capture` times but
doesnt run it itself.

```gleam
import gflambe
import gleam/erlang/process
import math

pub fn main() {
  options = [
    gflambe.OutputFormat(gflambe.Svg),
    gflambe.OutputDirectory("/tmp"),
  ]

  process.spawn(fn() {
    process.sleep(1000)
    math.sum([1, 2, 3, 4, 5])
  })

  gflambe.capture(#("math", "sum", 1), 5, options)
}
```

> [!NOTE]
> Check the [eflambe](https://github.com/Stratus3D/eflambe) documentation for more
> information about how the library works and how it gets the data from the execution.
