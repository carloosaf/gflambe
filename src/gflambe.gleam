//// # Gflambe
//// The main gflambe module. Defines the two functions that
//// let you start the process of generating the flame graph.

import gleam/erlang/atom.{type Atom}

/// The format of the flame graph
pub type EflambeFormat {
  Svg
  BrendanGregg
}

/// The program that will be used to open the flame graph
pub type EflambeOpenProgram {
  Speedscope
  Hotspot
}

/// The options that can be passed to the `apply` and `capture` functions.
///
/// ### OutputFormat
/// The format of the flame graph. Currently only `Svg` and `BrendanGregg` are supported.
///
/// ### OutputDirectory
/// The directory where the flame graph will be generated. If not specified
/// the current directory will be used.
///
/// ### Open
/// If this option is present the flame graph will be opened in the default
/// program for the specified format.
pub type EflambeOptions {
  OutputFormat(EflambeFormat)
  OutputDirectory(String)
  Open(EflambeOpenProgram)
}

/// The module, name and arity of the function we want to capture
/// The module must be specified as the real module name for the 
/// VM. Gleam modules are named with the `@` character. For example,
/// `gleam@string` is the module name for the `string` module.
pub type GflambeFunction {
  GflambeFunction(module: String, function_name: String, arity: Int)
}

/// This method will run the specified anonymous function given
/// as the first parameter and generate a flame graph from its execution.
/// The third argument is an options array that may be empty
///
/// ## Example
/// ```gleam
/// gflambe.apply(
///   fn() {
///     string.append("hello", "world")
///     Nil
///   },
///   [],
/// )
/// ```
pub fn apply(function: fn() -> Nil, options: List(EflambeOptions)) {
  external_apply(#(function, []), options)
}

@external(erlang, "eflambe", "apply")
fn external_apply(
  // The list will always be empty. There is no way of typing a function of an unknown arity
  subject: #(fn() -> Nil, List(never)),
  options: List(EflambeOptions),
) -> void

/// Start a process that waits for the function specified as the 
/// first argument to be run and creates its corresponding flame graph.
/// The function must be executed at least `number_of_calls_to_capture`
/// times for the graph to be generated. The third argument is an options
/// array that may be empty.
///
/// ## Example
/// ```gleam
/// gflambe.capture(GflambeFunction("gleam@string", "append", 2), 1, [])
/// ```
pub fn capture(
  function: GflambeFunction,
  number_of_calls_to_capture: Int,
  options: List(EflambeOptions),
) {
  let GflambeFunction(module, function_name, arity) = function

  let module_atom = atom.create(module)
  let function_name_atom = atom.create(function_name)

  external_capture(
    #(module_atom, function_name_atom, arity),
    number_of_calls_to_capture,
    options,
  )
}

@external(erlang, "eflambe", "capture")
fn external_capture(
  subject: #(Atom, Atom, Int),
  number_of_calls_to_capture: Int,
  options: List(EflambeOptions),
) -> void
