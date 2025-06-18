# gflambe 🧯

[![Package Version](https://img.shields.io/hexpm/v/gflambe)](https://hex.pm/packages/gflambe)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gflambe/)

Generate flame graphs from Gleam programs. This is a wrapper for the Erlang library [eflambe](https://github.com/Stratus3D/eflambe)

## Installation

```sh
gleam add gflambe
```

## Usage

This library provides two main functions. We'll use `string.append` as 
an example subject for the graph.


### `apply` 

This method takes a function that returns Nil and a list of options, and
generates a flame graph from its execution.

```gleam
import gflambe
import gleam/string

pub fn main() {
  gflambe.apply(
    fn() {
      let _ = string.append("hello", "world")
      Nil
    },
    [gflambe.OutputDirectory("./test")],
  )
}
```

### `capture`

This method takes: a tuple with the module name, function name and arity, a 
number of calls to capture and a list of options. It waits for the function
to be called `number_of_calls_to_capture` times but doesn't run it itself.

```gleam
import gflambe
import gleam/erlang/process
import gleam/string

pub fn main() {
  process.spawn(fn() {
    process.sleep(500)
    string.append("hello", "world")
  })

  gflambe.capture(GflambeFunction("gleam@string", "append", 2), 1, [])
}
```

> [!NOTE]
> See the [eflambe](https://github.com/Stratus3D/eflambe) documentation for more
> information about how the library works and how it gets the data from the execution.
