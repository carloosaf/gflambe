import gleam/erlang/atom.{type Atom}

pub type EflambeFormat {
  Svg
  BrendanGregg
}

pub type EflambeReturn {
  Value
  Flamegraph
  Filename
}

pub type EflambeOpenProgram {
  Speedscope
  Hotspot
}

pub type EflambeOptions {
  OutputFormat(EflambeFormat)
  Return(EflambeReturn)
  OutputDirectory(String)
  Open
}

@external(erlang, "eflambe", "apply")
pub fn apply(
  funtion: #(fn(input_type) -> return, List(input_type)),
  options: List(EflambeOptions),
) -> void

pub fn capture(
  function: #(String, String, Int),
  number_of_calls_to_capture: Int,
  options: List(EflambeOptions),
) {
  let atoms_subject = atom.create(function.0)
  let atoms_subject2 = atom.create(function.1)

  external_capture(
    #(atoms_subject, atoms_subject2, function.2),
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
